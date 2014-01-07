class WebsiteCreator

	def self.create(urls)
		website = Website.create
		urls.each do |url|
			html = PageRetriver.retrive(url)
			if html
				subpage = SubpageCreator.create(html)
				subpage.url = url
				subpage.website = website
				subpage.save
			else
				Subpage.create_invalid(url)
			end
		end
		website
	end

end