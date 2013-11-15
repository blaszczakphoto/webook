require 'pismo'
require 'open-uri'
require 'debugger'
require 'sanitize'
require 'readability'

class Subpage < ActiveRecord::Base
  belongs_to :page

  has_many :similar_subpages_association, :class_name => "SimilarSubpage"
  has_many :similar_subpages, :through => :similar_subpages_association, :uniq => true

  attr_accessible :title, :url, :datetime, :content, :valid_page, :page, :similar_subpages, :html
  attr_accessor :nokogiri_doc
  scope :valid_pages, -> { where(valid_page: true) }
  after_create :valid_url!, :open_url!, :parse!
  
  def open_url!
    if self.valid_page
      begin
        html_response = open(self.url)      
      rescue
        self.update_attributes(valid_page: false)
      else
        if html_response.status[0] == "200" && html_response.content_type == "text/html"
          html = html_response.read.force_encoding("utf-8")
          self.update_attributes(valid_page: true, html: html)
        else
          self.update_attributes(valid_page: false)
        end
      end
    end
  end

  def parse!
    if self.valid_page
      self.content = self.parse_content
      self.title = self.parse_header
      self.save
    end
  end

  def parse_content
    contents = []
    contents << Pismo::Document.new(self.html, :all_images => true).html_body
    #cluster_content = Pismo::Document.new(self.html, :all_images => true, :reader => :cluster).html_body
    contents << Readability::Document.new(self.html, :tags => %w[div p img a br ul li ol i b h1 h2 h3 h4 h5 td], 
                          :attributes => %w[src href], :remove_empty_nodes => false).content
    contents.max_by {|x| clean_content(x).length}
  end

  def self.remove_duplicates!
    valid_pages = scoped.valid_pages
    valid_pages.each do |subpage|
      valid_pages.where("id != ?", subpage.id).each do |iterated_subpage|
        if subpage.is_duplicate?(iterated_subpage)
          subpage.similar_subpages << iterated_subpage
          iterated_subpage.similar_subpages << subpage
        end
        iterated_subpage.save
      end
      subpage.save
    end


    valid_pages.each do |subpage|
      if subpage.valid_page && subpage.similar_subpages.count >= 1
        
        subpages = subpage.similar_subpages << subpage
        original = subpages.min_by {|x| x.count_links } 
        subpages.delete(original)

        subpages.each do |duplicated_subpage|
          duplicated_subpage.update_attributes(valid_page: false)
        end
      end
    end
  end

  def is_duplicate?(iterated_subpage)
    content_check, content_iterated = self.clean_content, iterated_subpage.clean_content
    maxlen = content_check.length
    maxlen.downto(0) do |len|
      next unless len % 10 == 0
      0.upto(maxlen - len) do |start|
        next unless start % 10 == 0
        break if (len - start) < 100 # Common part must be longer than 100 chars
        return true if content_iterated.include?(content_check[start,len])
      end
    end
    return false
  end

  def clean_content(content = false)
    content = self.content unless content
    Sanitize.clean(content).gsub("\n","").strip
  end

  def count_links
    Nokogiri::HTML(self.html).search("a").size
  end

  def parse_header
    self.nokogiri_doc = Nokogiri::HTML(self.html)
    content_pos = position_in_html(self.content)
    min_distance = 0
    headers = []
    self.nokogiri_doc.css("h1, h2, .header").each do |title|
      title_pos = position_in_html(title.content)
      if title_pos < content_pos && in_min_distance?(title_pos, content_pos)
        headers[title_pos] = {title: title, pos: title_pos}
      end
    end
    best_match_header(headers)
  end

  # Private
  def best_match_header(headers)
    return default_header if headers.empty?
    
    header_closer, header_further = headers.uniq.last(2).reverse
    if (not header_further) ||
      (header_further && 
        header_value(header_closer) <= header_value(header_further) && 
        in_min_distance?(header_closer[:pos], header_further[:pos]))
      return header_closer[:title].content
    else
      return header_further[:title].content
    end
  end

  # Private
  def header_value(header)
    matches = /h(?<number>\d)/.match(header[:title].name)
    return matches[1].to_i if matches     
    return 10 unless matches
  end

  # Private
  def default_header
    begin
      header = @nokogiri_doc.at_css("title").content
    rescue
      header = ""
    end
    return header
  end

  # Private
  def in_min_distance?(pos1, pos2)
    pos1 - pos2 < 100
  end

  # Private
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

  def collect_urls
    collected_urls = []
    self.nokogiri_doc.css("a").each do |url|
      href = prepare_url(url['href'])
      next unless href      
      if page.url_in_base?(href) and not page.url_stored?(href)
        collected_urls.push(href)
      end
    end
    collected_urls
  end

  # Private
  def prepare_url(href)
    return false if href.nil?
    href = add_http(href) unless href.include? "http"
    href = href.gsub("//", "/")
    href = href.gsub("http:/", "http://")
    href = href.gsub(/#.*/, "")
  end

  # Private
  def add_http(href)
    @page.base_url + href
  end

  def valid_url!
    if /.(jpg|gif|png|jpeg|JPG|GIF|PNG|SWF|swf)$/.match(url).nil?
      self.valid_page = true 
    else
      self.valid_page = false
    end
    self.save
  end
end