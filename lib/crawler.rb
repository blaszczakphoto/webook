require 'nokogiri'
require 'open-uri'

class Crawler

  attr_reader :website

  def initialize(base_url)    
    @website = Website.create!(base_url: base_url)
    @url_collector = UrlCollector.new(@website)
    @url_collector.current_url = @website.base_url
  end

  def run
    counter = 1
    until @url_collector.current_url.nil? do
      counter += 1
      break if counter == 30
      p "*"*5 + @url_collector.current_url + "*"*5

      @website.subpages << subpage = SubpageCreator.create(@url_collector.current_url)
      @url_collector.collect(subpage) if subpage.valid_page
      @url_collector.current_url = @url_collector.next_url
    end
    
    @website.save
  end

end
