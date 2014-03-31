require "content_finder"
require "header_finder"
require "debugger"

class SubpageCreator

	def self.create(url)
		html = PageRetriver.retrive(url)
		if html
			html = ContentCleaner.make_images_absolute(html, url)
			content = ContentFinder.find(html)
			title = HeaderFinder.find(html, content)
			subpage = Subpage.new(content: content, title: title)
			subpage.html = html
			subpage.url = url
			subpage.save
		else
			subpage = Subpage.create_invalid(url)
		end		
		return subpage
	end

	def self.from_html(html)
		content = ContentFinder.find(html)
		title = HeaderFinder.find(html, content)
		subpage = Subpage.new(content: content, title: title)
		subpage.html = html
		subpage.save
		subpage
	end

end