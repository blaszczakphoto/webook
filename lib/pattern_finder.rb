class PatternFinder
	attr_reader :patterns

# TODO: do sth with repeated looking for the same pattern /html/...
	def initialize(website)
		@base_url = website.base_url
		@website = website
		@patterns = []
		@crawler_patterns = [] # Only those patterns are used in crawler
		@base_url_length ||= @base_url.length
		@tested_patterns = []
	end

	def find(urls)
		substr = longest_common_substr(remove_base(urls))
		return false if pattern_blank?(substr)
		pattern = create_pattern(substr, urls)
		if !@tested_patterns.include?(pattern) && test_pattern(pattern, urls) && !@patterns.include?(pattern)
			p "pattern " + pattern.to_s
			@patterns.push(pattern) 
			return true
		else
			return false
		end
	end

	# Find and add pattern, but only to crawler testing
	def find_for_crawler(urls)
		if find(urls)
			@crawler_patterns.push(@patterns.last)
			return true
		else
			return false
		end
	end

	def pattern_blank?(str)
		!str || str == @base_url
	end

	# Check if examined pattern fits urls and valid pages do not fit
	def test_pattern(pattern, urls)
		@tested_patterns.push(pattern)
		urls.each {|url| return false unless (url =~ pattern)}
		fit_valid_counter = 0
		fit_invalid_counter = 0
		@website.subpages.each {|subpage| fit_valid_counter += 1 if subpage.valid_page && (subpage.url =~ pattern)}
		@website.subpages.each {|subpage| fit_invalid_counter += 1 if !subpage.valid_page && (subpage.url =~ pattern)}

		return false if fit_valid_counter > 1
		true
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
		@patterns.each {|pattern| return true if url =~ pattern} if @patterns.any?
		false
	end

	# Used only in crawler. It checks if url has pattern in duplicates without any links
	def has_pattern_for_crawler?(url)
		@crawler_patterns.each {|pattern| return true if url =~ pattern} if @crawler_patterns.any?
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