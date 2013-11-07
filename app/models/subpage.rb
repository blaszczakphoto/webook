require 'pismo'
require 'open-uri'

class Subpage < ActiveRecord::Base
  belongs_to :page
  attr_accessible :title, :url, :datetime, :content

  def self.create_from_url(url, page, html)
    subpage = Subpage.new
    subpage.url = url
    subpage.page = page
    subpage.save!

    subpage.parse_content!(html)
    subpage.parse_title!(html)
  end

  def parse_content!(html)
    pismo_doc = Pismo::Document.new(html)
    self.content = pismo_doc.html_body

    self.save
  end

  def parse_title!(html)
    @nokogiri_doc = Nokogiri::HTML(html)
    self.title = @nokogiri_doc.at_css("title").content
    content_pos = content_pos(html)
    min_distance = 0
    @nokogiri_doc.css("h1").each do |title|
      title = title.content
      title_pos = html.index(title)
      
      if title_pos < content_pos && title_pos > min_distance
        
        min_distance = title_pos
        self.title = title
      end
    end

    self.save
  end

  private
  def content_pos(html)
    i = 200
    pure_content = ActionController::Base.helpers.strip_tags(content).strip
    loop do 
      truncated_content = pure_content.slice(0, i)
      pos = html.index(truncated_content)       
      return pos unless pos.nil?
      i -= 20
    end
  end

end