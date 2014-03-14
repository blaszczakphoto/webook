class PatternFinder

	attr_accessor :original_patterns, :patterns, :trash_patterns, :subpages

	def initialize(website)
		@base_url = website.base_url
		@website = website
		@subpages = @website.subpages
		@base_url_length ||= @base_url.length
	end


	def find(subpages)
		urls = subpages.first.url, subpages.last.url
		substr = longest_common_substr(remove_base(urls))
		return false if pattern_blank?(substr)
		return create_pattern(substr, urls)

		pattern = find_pattern(urls)
		return false unless pattern
	end

	def pattern_blank?(str)
		!str || str == @base_url
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