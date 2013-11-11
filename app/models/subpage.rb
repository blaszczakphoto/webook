require 'pismo'
require 'open-uri'
require 'net/http'
require 'debugger'
require 'sanitize'


class Subpage < ActiveRecord::Base
  belongs_to :page
  has_many :similar_subpages, :class_name => 'Subpage'
  accepts_nested_attributes_for :similar_subpages
  attr_accessible :title, :url, :datetime, :content, :valid_page, :page, :similar_subpages
  attr_accessor :html
  after_create :valid_page!
  scope :valid_pages, -> { where(valid_page: true) }


  def self.create_from_url(data)
    subpage = Subpage.create!(url: data[:url], page: data[:page])
    subpage.html = data[:html]

    if subpage.valid_page
      subpage.content = subpage.parse_content
      subpage.title = subpage.parse_header
      subpage.save
    end

  end

  def parse_content
    pismo_doc = Pismo::Document.new(self.html, :all_images => true)
    pismo_doc.html_body
  end

  def self.remove_duplicates!
    valid_pages = scoped.valid_pages
    valid_pages.each do |subpage|
      #debugger
      cleaned_subpage = clean_content(subpage.content)
      valid_pages.where("id != ?", subpage.id).each do |iterated_subpage|
        if clean_content(iterated_subpage.content).include?(cleaned_subpage)
          subpage.update_attributes(valid_page: false)
          break
        end
      end     
    end
  end

  # Clean html tags
  def self.clean_content(content)
    Sanitize.clean(content).gsub("\n","").strip[10..-10]
  end

  def parse_header
    @nokogiri_doc = Nokogiri::HTML(self.html)
    content_pos = position_in_html(self.content)
    min_distance = 0
    headers = []
    @nokogiri_doc.css("h1, h2, .header").each do |title|
      title_pos = position_in_html(title.content)
      if title_pos < content_pos && in_min_distance?(title_pos, content_pos)
        headers[title_pos] = {title: title, pos: title_pos}
      end
    end
    best_match_header(headers)
  end

  def best_match_header(headers)
    return default_header if headers.empty?
    
    header_closer, header_further = headers.uniq.last(2).reverse
    debugger if header_closer.nil?
    if (not header_further) ||
      (header_further && 
        header_value(header_closer) <= header_value(header_further) && 
        in_min_distance?(header_closer[:pos], header_further[:pos]))
      return header_closer[:title].content
    else
      return header_further[:title].content
    end
  end

  def header_value(header)
    matches = /h(?<number>\d)/.match(header[:title].name)
    return matches[1].to_i if matches     
    return 10 unless matches
  end

  def default_header
    begin
      header = @nokogiri_doc.at_css("title").content
    rescue
      header = ""
    end
    return header
  end

  def in_min_distance?(pos1, pos2)
    pos1 - pos2 < 100
  end

  def position_in_html(content)
    i = 200
    pure_content = ActionController::Base.helpers.strip_tags(content).strip
    loop do 
      truncated_content = pure_content.slice(0, i)
      pos = self.html.index(truncated_content)
      return pos unless pos.nil?
      i -= 10
    end
    return false
  end

  def valid_page!
    return unless self.valid_page.nil?
    
    url = URI.parse(self.url)
    Net::HTTP.start(url.host, url.port) do |http|   
      if http.head(url.request_uri).code == "200" && http.head(url.request_uri)['Content-Type'].include?("html")  
        self.valid_page = true
      else
        self.valid_page = false
      end
    end   
    self.save
  end



end