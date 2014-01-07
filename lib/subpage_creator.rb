require "content_finder"
require "header_finder"

class SubpageCreator

	def self.create(html)
		content = ContentFinder.find(html)
		title = HeaderFinder.find(html, content)
		subpage = Subpage.new(content: content, title: title)
		subpage.html = html
		subpage.save
		subpage
	end

end