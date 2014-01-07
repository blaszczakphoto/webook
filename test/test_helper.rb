ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase

  fixtures :all

  def create_subpages_from_urls(urls)
  	subpages = []
  	urls.each do |url|
  		subpages << Subpage.create(url: url)
  	end
  	subpages
  end

end
