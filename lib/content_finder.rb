require 'pismo'
require 'readability'

class ContentFinder

	def self.find(html)
		contents = []
		# Pismo::Document.new(html, :all_images => true).html_body
		Readability::Document.new(html, :tags => %w[div p img a span br ul li ol i b h1 h2 h3 h4 h5 td], 
                          :attributes => %w[src href], :remove_empty_nodes => false).content

		# contents.max_by {|x| ContentCleaner.clean(x).length}
	end

end