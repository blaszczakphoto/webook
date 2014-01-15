class PatternFinder
	attr_reader :patterns

	def initialize(website)
		@base_url = website.base_url
		@website = website
		@patterns = []
		@base_url_length ||= @base_url.length
	end

	def find(urls)
		substr = longest_common_substr(remove_base(urls))
		return false if !substr || substr == @base_url
		pattern = create_pattern(substr, urls)
		if test_pattern(pattern, urls)
			@patterns.push(pattern)
			return true
		else
			return false
		end
	end

	# Check if examined pattern fits urls and valid pages do not fit
	def test_pattern(pattern, urls)
		urls.each {|url| return false unless (url =~ pattern)}
		@website.subpages.each {|subpage| return false if subpage.valid_page && (subpage.url =~ pattern)}
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

	def create_pattern(str, urls)
		return Regexp.new(@base_url + str) if pattern_in_begining?(str,urls)
		return Regexp.new(str + "$") if pattern_in_end?(str, urls)
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