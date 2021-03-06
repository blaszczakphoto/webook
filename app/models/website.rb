class Website < ActiveRecord::Base
	attr_accessible :base_url, :subpages
	has_many :subpages, dependent: :destroy

	def url_in_base?(url)
		url.include? base_url
	end

	def url_stored?(url)
		subpages.exists?(url: url)
	end

end