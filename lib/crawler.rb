# coding: utf-8
require 'nokogiri'
require 'open-uri'


class Crawler

  attr_reader :website, :crawler_optimizer
# TODO: initliaze to skip all 
# invalid pages on flow, use only those one which has no links_num, pass patterns do duplicate patterns

  def initialize(base_url)    
    @website = Website.create!(base_url: base_url)
    @url_collector = UrlCollector.new(@website)
    @url_collector.current_url = @website.base_url
    @crawler_optimizer = CrawlerOptimizer.new(@website)
  end

  def run(limit = false, duplicate_optimizer = false)
    @limit = limit
    @trash_count = 0
    until url_collector_empty? do
      break if limit_reached?
      
      if @crawler_optimizer.pattern?(@url_collector.current_url)
        @website.subpages << subpage = Subpage.create_invalid(@url_collector.current_url)
      else
        @website.subpages << subpage = SubpageCreator.create(@url_collector.current_url)
        if subpage.valid_page
          subpage.update_attributes(links_num: @url_collector.collect(subpage)) 
          p subpage.url
        else
          @trash_count += 1
          @crawler_optimizer.add_unoptimized(subpage)
        end
      end

      if @trash_count > 5
        p "optymalizacja w trakcie crawlowania.."
        @crawler_optimizer.optimize!
        @trash_count = 0
      end

      @url_collector.current_url = @url_collector.next_url
    end
    p "limit reached: " + @limit.to_s
    @website.save
  end

  def involve_duplicate_patterns(patterns)
    patterns.each {|pattern| @crawler_optimizer.add_duplicate_pattern(subpage)}
  end

  def url_collector_empty?
    @url_collector.current_url.nil?
  end

  def limit_reached?
    return false unless @limit
    @counter ||= 0
    @counter += 1
    @limit && @counter == @limit
  end

end
