require "pattern_finder"

class CrawlerOptimizer
	attr_reader :pattern_finder

	def initialize(website)
		@base_url = website.base_url
		@subpages = website.subpages
		
		@pattern_finder = PatternFinder.new(website)
	end

	def optimize!
		@unoptimized = find_unoptimized!
		@unoptimized.each_with_index do |subpage, index|
			next_subpage = @unoptimized[index + 1]
			break unless next_subpage
			@pattern_finder.find([subpage.url, next_subpage.url])
		end
	end

	def find_unoptimized!
		unoptimized = []
		@subpages.each do |subpage|
			unless @pattern_finder.has_pattern?(subpage.url) || subpage.valid_page
				unoptimized.push(subpage)
			end
		end
		unoptimized
	end
end