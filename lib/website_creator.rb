class WebsiteCreator

	def self.create(urls)
		website = Website.create
		urls.each do |url|
			website.subpages << SubpageCreator.create(url)
		end
		website.save
		website
	end

end