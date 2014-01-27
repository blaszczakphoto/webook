require "pattern_finder"

class CrawlerOptimizer
	attr_reader :pattern_finder, :add_to_unoptimized

	def initialize(website)
		@base_url = website.base_url
		@subpages = website.subpages
		@pattern_finder = PatternFinder.new(website)
	end

	def optimize!(subpages = nil)
		@unoptimized = subpages || unoptimized

			# @unoptimized.each do |subpage|
			# 	@unoptimized.each do |iterated_subpage|
			# 		next if subpage.url == iterated_subpage.url
			# 		t_subpages = [subpage.url, iterated_subpage.url]
			# 		@pattern_finder.find_original(t_subpages)
			# 	end
			# end

			@unoptimized.each do |subpage|
				@unoptimized.each do |iterated_subpage|
					next if subpage.url == iterated_subpage.url
					t_subpages = [subpage.url, iterated_subpage.url]
					if subpage.links_num > 0
						@pattern_finder.find_duplicate(t_subpages)
					else
						@pattern_finder.find_trash(t_subpages)
					end
				end
			end

	end

	def add(subpage)
		@unoptimized ||= []
		@unoptimized.push(subpage) unless @unoptimized.include?(subpage)
	end


	def unoptimized_duplicates
		@unoptimized ||= @subpages # Assign @subpages from init if there is no subpage added
		@unoptimized_duplicates ||= []
		@unoptimized.each do |subpage|
			# Add only if invalid, has no pattern yet and is not added yet
			if !subpage.valid_page && !duplicate?(url) && @unoptimized_duplicates.include?(subpage)
				unoptimized_duplicates.push(subpage) 
			end
		end
		unoptimized
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

	def duplicate?(url)	
		@pattern_finder.duplicate_patterns.each {|pattern| return true if url =~ pattern} if @pattern_finder.duplicate_patterns.any?
		false
	end

	def trash?(url)
		@trash_patterns.each {|pattern| return true if url =~ pattern} if @pattern_finder.trash_patterns.any?
		false
	end

	def original?(subpage)
		@original_patterns.each {|pattern| return true if url =~ pattern} if @pattern_finder.original_patterns.any?
		false
	end

end