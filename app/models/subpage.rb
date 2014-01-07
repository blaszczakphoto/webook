require 'debugger'

class Subpage < ActiveRecord::Base
  before_save :default_values
  belongs_to :website

  has_many :similar_subpages_association, :class_name => "SimilarSubpage"
  has_many :similar_subpages, :through => :similar_subpages_association, :uniq => true

  attr_accessible :title, :url, :datetime, :content, :valid_page, :website, :similar_subpages, :html

  scope :valid_pages, -> { where(valid_page: true) }

  def default_values
    self.valid_page ||= true
  end


  def self.create_invalid(url)
    Subpage.create(url: url, valid_page: false)
  end
  
  def clean_content
    Sanitize.clean(content).gsub("\n","").strip
  end

  def collect_urls
    collected_urls = []
    self.nokogiri_doc.css("a").each do |url|
      href = prepare_url(url['href'])
      next unless href      
      if website.url_in_base?(href) and not website.url_stored?(href)
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
    @website.base_url + href
  end


end