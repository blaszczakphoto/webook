class WebsiteCreator

	def self.create(urls)
		website = Website.create
		urls.each do |url|
			subpage = SubpageCreator.create(url)
			subpage.update_attributes(website:website) if subpage.valid_page
		end
		website.save
		website
	end

end