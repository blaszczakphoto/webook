module ApplicationHelper

	def active?(item_url)
		"class=active" if item_url.gsub("/", "") == request.fullpath.gsub("/", "")
	end
end
