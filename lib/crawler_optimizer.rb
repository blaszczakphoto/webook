require "pattern_finder"

class CrawlerOptimizer
	attr_reader :pattern_finder

	def initialize(website)
		@base_url = website.base_url
		@subpages = website.subpages

		@pattern_finder = PatternFinder.new(website)
	end

	def optimize!
		@unoptimized = unoptimized
		unoptimized.each do |subpage|
			@unoptimized.each do |iterated_subpage|
				next if subpage.url == iterated_subpage.url
				t_subpages = [subpage.url, iterated_subpage.url]
				if subpage.links_num > 0
					@pattern_finder.find(t_subpages)
				else
					@pattern_finder.find_for_crawler(t_subpages)
				end
			end
		end
	end

	def unoptimized
		unoptimized = []
		@subpages.each do |subpage|
			unless @pattern_finder.has_pattern?(subpage.url) || subpage.valid_page
				unoptimized.push(subpage)
			end
		end
		unoptimized
	end

end