class PatternTester

	def initialize(subpages)
		@subpages = subpages
	end

	def test(pattern)
		fits_more_duplicates?(pattern)
	end

	def fits_more_duplicates?(pattern)
		fit_valid_counter, fit_invalid_counter = 0, 0
		@subpages.each {|subpage| fit_valid_counter += 1 if subpage.valid_page && (subpage.url =~ pattern)}
		@subpages.each {|subpage| fit_invalid_counter += 1 if !subpage.valid_page && (subpage.url =~ pattern)}
		return true if more_invalid?(fit_valid_counter, fit_invalid_counter) && compare_to_all?(fit_valid_counter)
		return false
	end

	def compare_to_all?(fit_valid_counter)
		fit_valid_counter.to_f / @subpages.count < 0.2
	end

	def more_invalid?(fit_valid_counter, fit_invalid_counter)
		fit_invalid_counter.to_f / fit_valid_counter > 2
	end

	def has_links?(pattern)
		@subpages.each {|subpage| return true if (subpage.links_num > 0) && (subpage.url =~ pattern)}
		return false
	end

end