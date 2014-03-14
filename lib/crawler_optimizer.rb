require "pattern_finder"
require "pattern_tester"

class CrawlerOptimizer
	attr_reader :pattern_finder

	def initialize(website)
		@pattern_finder, @pattern_tester = PatternFinder.new(website), PatternTester.new(website.subpages)
		@patterns, @unoptimized = [], []
	end

	# Search invalid subpages for common pattern
	# 
	def optimize!
		@unoptimized.each do |subpage|
			@unoptimized.each do |iterated_subpage|
				next if subpage.url == iterated_subpage.url
				examined_subpages = [subpage, iterated_subpage]
				pattern = @pattern_finder.find(examined_subpages)
				if !@patterns.include?(pattern) && @pattern_tester.test(pattern)
					@patterns << pattern
					p "c pattern " + pattern.to_s
				end
			end
		end
	end

	# Add invalid subpages from Crawler
	# 
	def add_unoptimized(subpage)
		@unoptimized.push(subpage) unless @unoptimized.include?(subpage)
	end

	# Enable to get patterns from outside
	# 
	def add_duplicate_pattern(pattern)
		add(subpage)
	end


	# Check if url fits any pattern
	# 
	def pattern?(url)
		if @patterns.any?
			@patterns.each do |pattern| 
				if url =~ pattern
					p " "
					p "skip bo c pattern " + pattern.to_s + " " 
					p url
					p " "
					return true					
				end
			end
		end
		false
	end

end