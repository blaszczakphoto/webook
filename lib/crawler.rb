require 'nokogiri'
require 'open-uri'

class Crawler

  def initialize(url)    
    @page = Page.create!(base_url: url)
    @collected_urls = [url]
    @current_url = url
  end

  def run
    while not @collected_urls.empty? do
      @current_doc = Nokogiri::HTML(open(@current_url))
      subpage = Subpage.create_from_url(@current_url, @page)
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
      #p href
      if @page.url_in_base?(href) and not @page.url_stored?(href)
        @collected_urls.push(href)
      end
    end
  end

end
