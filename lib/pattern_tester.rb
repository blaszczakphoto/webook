class PatternTester

	attr_accessor :subpages

	def initialize(subpages = false)
		@subpages = subpages
		@tested_patterns = []
	end

	def test(pattern)
		@tested_patterns.push(pattern) unless already_tested?(pattern)
		fits_only_duplicates?(pattern)
	end

	def fits_only_duplicates?(pattern) #TODO: try to removge subpages as arg, reference.
		@subpages.each {|subpage| return false if subpage.valid_page && (subpage.url =~ pattern)}
		return true
	end

	def already_tested?(pattern)
		@tested_patterns.include?(pattern)
	end

	def has_links?(pattern, subpages)
		subpages.each {|subpage| return true if subpage.links_num > 0}
		@subpages.each {|subpage| return true if (subpage.links_num > 0) && (subpage.url =~ pattern)}
		false
	end

end