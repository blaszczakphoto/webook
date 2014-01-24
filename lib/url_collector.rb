require "nokogiri"

class UrlCollector

	attr_accessor :collected_urls, :current_url

	def initialize(website)
	  @website = website
	  @collected_urls = [@website.base_url]
	end

	def collect(subpage)
		counter = 0
		Nokogiri::HTML(subpage.html).css("a").each do |url|
			href = prepare_url(url['href'])
			next unless href
			if @website.url_in_base?(href) && !@website.url_stored?(href) && !@collected_urls.include?(href)
				@collected_urls.push(href)
				counter += 1
			end
		end
		counter
	end

	def next_url
		@collected_urls.delete(@current_url)
    @collected_urls.first
	end

	def prepare_url(href)
		return false if href.nil?
		href = add_http(href) unless href.include? "http"
		href = href.gsub("//", "/")
		href = href.gsub("http:/", "http://")
		href = href.gsub(/#.*/, "")
	end

	def add_http(href)
    @website.base_url + href
  end

end