require 'nokogiri'
require 'open-uri'

class Crawler

  attr_reader :page

  def initialize(url)    
    @page = Page.create!(base_url: url)
    @collected_urls = [url]
    @current_url = url
  end

  def run
    until @collected_urls.empty? do
      begin
        html = open(@current_url).read.force_encoding("utf-8")
      rescue    
        Subpage.create!(valid_page: false, url: @current_url, page: @page)
        next_url
        next
      end

      @current_doc = Nokogiri::HTML(html)
      Subpage.create_from_url(url: @current_url, page: @page, html: html)
      collect_urls
      next_url
    end
  end

  private
  def next_url
    @collected_urls.delete(@current_url)
    @current_url = @collected_urls.first
  end

  private
  def collect_urls
    @current_doc.css("a").each do |url|
      href = prepare_url(url['href'])
      next unless href      
      if @page.url_in_base?(href) and not @page.url_stored?(href)
        @collected_urls.push(href)
      end
    end
  end

  private
  def prepare_url(href)
    return false if href.nil?
    href = add_http(href) unless href.include? "http"
    href = href.gsub("//", "/")
    href = href.gsub("http:/", "http://")
    href = href.gsub(/#.*/, "")
  end

  private
  def add_http(href)
    @page.base_url + href
  end

end
