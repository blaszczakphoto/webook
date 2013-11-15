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
      @page.subpages << subpage = Subpage.create(url: @current_url)
      @page.save
      next_url
      next if not subpage.valid_page
      @collected_urls += subpage.collect_urls
    end
    @page.subpages.remove_duplicates!
  end

  def next_url
    @collected_urls.delete(@current_url)
    @current_url = @collected_urls.first
  end

end
