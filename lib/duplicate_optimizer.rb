require "pattern_finder"
require "pattern_tester"

class DuplicateOptimizer
	attr_reader :crawler_patterns, :duplicate_patterns
# TODO: write test with 100 first links from zjp. fix optimizer to find most of patterns like index.php and so on in first 100.
# test links which should have be pushed to crawler (all which did not collect any more links), 
	def initialize(website)
		@subpages = website.subpages
		@base_url = website.base_url
		@pattern_finder, @pattern_tester = PatternFinder.new(website), PatternTester.new(@subpages)
		@crawler_patterns, @duplicate_patterns = [], []
	end

	def optimize!
		unoptimized = duplicates
		unoptimized.each do |subpage|
			unoptimized.each do |iterated_subpage|
				next if subpage.url == iterated_subpage.url
				t_subpages = [iterated_subpage, subpage]
				pattern = @pattern_finder.find(t_subpages)
				collect_pattern(t_subpages, pattern)
			end
		end
	end

	def collect_pattern(t_subpages, pattern)
		
		unless @duplicate_patterns.include?(pattern)
			if @pattern_tester.test(pattern)
				@duplicate_patterns.push(pattern) 
				p "d pattern " + pattern.to_s
				if !@crawler_patterns.include?(pattern) && !@pattern_tester.has_links?(pattern)
					@crawler_patterns.push(pattern) 
					# p "c pattern " + pattern.to_s
				end
			end
		end
	end

	def add(subpage)
		@unoptimized ||= []
		@unoptimized.push(subpage) unless @unoptimized.include?(subpage)
	end

	def duplicates
		@unoptimized ||= @subpages # Assign @subpages from init if there is no subpage added
		@unoptimized_duplicates ||= []
		@unoptimized.each do |subpage|
			# Add only if invalid, has no pattern yet and is not added yet
			if !subpage.valid_page && !pattern?(subpage.url) && !@unoptimized_duplicates.include?(subpage)
				@unoptimized_duplicates.push(subpage) 
			end
		end
		@unoptimized_duplicates
	end

	def pattern?(url)	
		@duplicate_patterns.each {|pattern| return true if url =~ pattern} if @duplicate_patterns.any?
		false
	end

end