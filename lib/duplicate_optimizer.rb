require "pattern_finder"

class DuplicateOptimizer
	attr_reader :pattern_finder

	def initialize(website)
		@base_url = website.base_url
		@pattern_finder = PatternFinder.new(website)
	end

	def optimize!
		# TODO: Test it

		@pattern_finder.subpages = @unoptimized # Work only on subpages checked for duplicates
		unoptimized = duplicates
		unoptimized.each do |subpage|
			unoptimized.each do |iterated_subpage|
				next if subpage.url == iterated_subpage.url
				@pattern_finder.find_duplicate([subpage.url, iterated_subpage.url])
			end
		end

		#TODO as above but for originales
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
			if !subpage.valid_page && !duplicate?(subpage.url) && !@unoptimized_duplicates.include?(subpage)
				@unoptimized_duplicates.push(subpage) 
			end
		end

		@unoptimized_duplicates
	end

	def originales
		
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