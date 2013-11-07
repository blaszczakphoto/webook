require 'nokogiri'
require 'open-uri'

class Crawler

  def initialize(url)    
    @page = Page.create!(base_url: url)
    @collected_urls = [url]
    @current_url = url
  end

  def run
    until @collected_urls.empty? do
      html = open(@current_url).read.force_encoding("utf-8")
      @current_doc = Nokogiri::HTML(html)
      Subpage.create_from_url(@current_url, @page, html)
      collect_urls
      set_current_url
    end
  end

  private
  def set_current_url
    @collected_urls.delete(@current_url)
    @current_url = @collected_urls.first
  end

  private
  def collect_urls
    @current_doc.css("a").each do |url|
      href = url['href']
      next if href.nil?
      if @page.url_in_base?(href) and not @page.url_stored?(href)
        @collected_urls.push(href)
      end
    end
  end

end
