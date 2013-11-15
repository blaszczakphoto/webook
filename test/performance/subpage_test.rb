require 'test_helper'
require 'rails/performance_test_help'

class SubpageTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  self.profile_options = { :runs => 3, :metrics => [:wall_time, :process_time],
                           :output => 'tmp/performance', :formats => [:graph] }
                           
  def test_creation
    Subpage.create :url => "http://www.loswiaheros.pl/australia/667-aborygeni-ostatni-koczownicy"
  end

end
