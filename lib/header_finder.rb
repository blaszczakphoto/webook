require "nokogiri"
require "action_controller"

class HeaderFinder

	def self.find(html, content)
		@html, @content = html, content
		parse_header
	end

	def self.parse_header
		@nokogiri = Nokogiri::HTML(@html)
		content_pos = position_in_html(@content)
		min_distance = 0
		headers = []
		@nokogiri.css("h1, h2, .header").each do |title|
			title_pos = position_in_html(@content)
			if title_pos < content_pos && in_min_distance?(title_pos, content_pos)
				headers[title_pos] = {title: title, pos: title_pos}
			end
		end
		best_match_header(headers)
	end

	def self.best_match_header(headers)
    return default_header if headers.empty?
    
    header_closer, header_further = narrow_to_closest(headers, 2)
    if (not header_further) ||
      (header_further && 
        header_value(header_closer) <= header_value(header_further) && 
        in_min_distance?(header_closer[:pos], header_further[:pos]))
      return header_closer[:title].content
    else
      return header_further[:title].content
    end
  end

  def self.narrow_to_closest(headers, number)
  	headers.uniq.last(2).reverse
  end

  # Private
  def self.header_value(header)
    matches = /h(?<number>\d)/.match(header[:title].name)
    return matches[1].to_i if matches     
    return 10 unless matches
  end

  # Private
  def self.default_header
    begin
      header = @nokogiri.at_css("title").content
    rescue
      header = ""
    end
    return header
  end

  # Private
  def self.in_min_distance?(pos1, pos2)
    pos1 - pos2 < 100
  end

  # Private
  def self.position_in_html(content)
    i = 200
    pure_content = ContentCleaner.clean(content)
    loop do 
      truncated_content = pure_content.slice(0, i)
      pos = @html.index(truncated_content)
      return pos unless pos.nil?
      i -= 10
    end
    return false
  end

end

