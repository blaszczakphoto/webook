require 'nokogiri'
require 'open-uri'

class Crawler

  attr_reader :website

  def initialize(base_url)    
    @website = Website.create!(base_url: base_url)
    @url_collector = UrlCollector.new(@website)
    @url_collector.current_url = @website.base_url
  end

  def run(args)
    @optimizer, @limit = prepare_args(args)
    until @url_collector.current_url.nil? do
      break if limit_reached?
      
      unless @optimizer && useless_link?(@url_collector.current_url)
        @website.subpages << subpage = SubpageCreator.create(@url_collector.current_url)
        subpage.update_attributes(links_num: @url_collector.collect(subpage)) if subpage.valid_page
        p subpage.valid_page.to_s + " " + @url_collector.current_url
      else
        p "pominieto z uwagi na crawler pattern! :)" + @url_collector.current_url
        @website.subpages << subpage = Subpage.create_invalid(@url_collector.current_url)
      end

      @url_collector.current_url = @url_collector.next_url
    end
    p "limit reached: " + @limit.to_s
    @website.save
  end

  def useless_link?(url) 
    @optimizer.pattern_finder.has_pattern_for_crawler?(url)
  end

  def prepare_args(args)
    [args[:optimizer] || false, args[:limit] || false]
  end

  def limit_reached?
    return false unless @limit
    @counter ||= 0
    @counter += 1
    @limit && @counter == @limit
  end



end
