require 'test_helper'
require 'crawler'
class CrawlerTest < ActiveSupport::TestCase

  test "only url which are in base url" do
    crawler = Crawler.new("http://localhost:3000/example/")
    crawler.run

    assert !Subpage.exists?(url: "http://localhost:3000/")
    assert Subpage.exists?(url: "http://localhost:3000/example/")
    assert Subpage.exists?(url: "http://localhost:3000/example/1.html")
    assert !Subpage.exists?(url: "http://wp.pl/")
  end

  test "urls are uniq" do
    crawler = Crawler.new("http://localhost:3000/example/")
    crawler.run

    assert_equal 1, Subpage.where(url: "http://localhost:3000/example/").count
    assert_equal 1, Subpage.where(url: "http://localhost:3000/example/1.html").count
  end


  test "store links also from subpages" do
    crawler = Crawler.new("http://localhost:3000/example/")
    crawler.run

    assert Subpage.exists?(url: "http://localhost:3000/example/2.html")
  end




end