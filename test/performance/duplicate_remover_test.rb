require 'test_helper'
require 'rails/performance_test_help'

class DuplicateRemoverTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  self.profile_options = { :runs => 3, :metrics => [:wall_time, :process_time],
  	:output => 'tmp/performance', :formats => [:graph] }
  	
  	def test_creation
  		urls = [
  			"http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku/",
  			"http://www.zyciejestpiekne.eu/"
  		]
  		book = BookCreator.create(urls)
  		subpages = DuplicateRemover.remove(book.website.subpages)
  	end

  end
