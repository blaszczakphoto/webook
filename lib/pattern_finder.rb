class PatternFinder

	attr_accessor :original_patterns, :duplicate_patterns, :trash_patterns, :subpages

	def initialize(website)
		@base_url = website.base_url
		@website = website
		@subpages = @website.subpages
		@base_url_length ||= @base_url.length

		@tested_patterns = []
		@original_patterns = []
		@duplicate_patterns = []
		@trash_patterns = [] # Only those patterns are used in crawler
	end

	def find_original(urls)

		pattern = find_pattern(urls)
		return false unless pattern
		if !@tested_patterns.include?(pattern) && !@original_patterns.include?(pattern) && test_original_pattern(pattern, urls)
			p "pattern " + pattern.to_s
			@duplicate_patterns.push(pattern) 
			return true
		else
			return false
		end
	end

	def find_pattern(urls)
		substr = longest_common_substr(remove_base(urls))
		return false if pattern_blank?(substr)
		create_pattern(substr, urls)
	end

	def find_duplicate(urls)
		# debugger if urls.first.include?("#disqus_thread") && urls.last.include?("#disqus_thread")
		pattern = find_pattern(urls)
		return false unless pattern
		if !@tested_patterns.include?(pattern) && !@duplicate_patterns.include?(pattern) && test_duplicate_pattern(pattern, urls)
			p "pattern " + pattern.to_s
			@duplicate_patterns.push(pattern) 
			return true
		else
			return false
		end
	end

	# Find and add pattern, but only to crawler testing
	def find_trash(urls)
		if find_duplicates(urls)
			@trash_patterns.push(@duplicate_patterns.last)
			return true
		else
			return false
		end
	end

	def pattern_blank?(str)
		!str || str == @base_url
	end


	# Check if examined pattern fits urls and valid pages do not fit
	def test_duplicate_pattern(pattern, urls)

		@tested_patterns.push(pattern)
		urls.each {|url| return false unless (url =~ pattern)}
		fit_valid_counter = 0
		fit_invalid_counter = 0
		@subpages.each {|subpage| fit_valid_counter += 1 if subpage.valid_page && (subpage.url =~ pattern)}
		@subpages.each {|subpage| fit_invalid_counter += 1 if !subpage.valid_page && (subpage.url =~ pattern)}

		# @website.subpages.each {|subpage| return false if subpage.valid_page && (subpage.url =~ pattern)}

		return true if fit_valid_counter <= 1 && fit_invalid_counter > 1
		return false
	end

	def remove_base(urls)
		urls.map { |url| without_base(url) }
	end

	def longest_common_substr(strings)
		shortest = strings.min_by &:length
		maxlen = shortest.length
		maxlen.downto(0) do |len|
			0.upto(maxlen - len) do |start|
				substr = shortest[start,len]
				next if substr.length < 4
				return substr if strings.all?{|str| str.include? substr }
			end
		end
		false
	end

	def has_pattern?(url)
		@duplicate_patterns.each {|pattern| return true if url =~ pattern} if @duplicate_patterns.any?
		false
	end

	# Used only in crawler. It checks if url has pattern in duplicates without any links
	def has_trash_pattern?(url)
		@trash_patterns.each {|pattern| return true if url =~ pattern} if @trash_patterns.any?
		false
	end

	def create_pattern(str, urls)
		return Regexp.new(@base_url + prepare_str(str)) if pattern_in_begining?(str,urls)
		return Regexp.new(prepare_str(str) + "$") if pattern_in_end?(str, urls)
	end

	def prepare_str(str)
		str.gsub("?", "\\?")
	end

	def pattern_in_begining?(str, urls)
		urls[0].index(str) == @base_url_length
	end

	def without_base(str)
		str[@base_url_length, str.length] if str.include?(@base_url)
	end

	def pattern_in_end?(str, urls)
		(urls[0].length - str.length) == urls[0].index(str)
	end

end