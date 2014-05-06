require "sanitize"
require "debugger"
require "iconv"

class ContentCleaner

	def self.clean(content)
		content = force_utf(content)
		Sanitize.clean(content).gsub("\n","").strip		
	end

	def self.force_utf(content)
		content.force_encoding("ISO-8859-2") if content.encoding.to_s == "ASCII-8BIT"
		return content.encode('utf-8', :invalid => :replace, :undef => :replace)
	end

	def self.make_images_absolute(html, url)
		@doc = Nokogiri::HTML(html)
		@doc.search("img").each do |img| 
			if !img.attribute("src").value.include?("http") && !img.attribute("src").value.include?("www")
				img.attribute("src").value = "%s/%s" % [base_url(url), img.attribute("src").value]
			end
		end
		@doc.to_html
	end

	def self.base_url(url)
		uri = URI.parse(url)
		return "#{uri.scheme}://#{uri.host}"
	end

end