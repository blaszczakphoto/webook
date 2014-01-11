require 'pismo'
require 'readability'

class ContentFinder

	def self.find(html)

		# html = remove_problematic_content(html)
		# Pismo::Document.new(html, :all_images => true).html_body

		@content = Readability::Document.new(html, :tags => %w[div p img a span br ul li ol i b h1 h2 h3 h4 h5 td], :attributes => %w[src href], :remove_empty_nodes => false).content
		
		fix_encoding
	end

	def self.remove_problematic_content(html)
		html.gsub(/<\/?span.*?>/,'')
	end

	def self.fix_encoding
		if @content.encoding.to_s != "UTF-8"
			@content = @content.force_encoding("utf-8")
		end
		@content
	end

end