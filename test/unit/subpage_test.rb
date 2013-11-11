# encoding: utf-8
require 'test_helper'
require 'crawler'

class SubpageTest < ActiveSupport::TestCase

  def setup
    crawler = Crawler.new("http://localhost:3000/example/")
    crawler.run
  end

  test "it has closest title just above content" do
    assert_equal "Pierwszy wpis!", Subpage.where(url: "http://localhost:3000/example/").first.title
    assert_equal "First wpis!", Subpage.where(url: "http://localhost:3000/example/1.html").first.title
    assert_equal "Pierwszy wpis!", Subpage.where(url: "http://localhost:3000/example/2.html").first.title
  end

  test "content not include header" do
    assert !Subpage.where(url: "http://localhost:3000/example/").first.content.include?("The first entry!")
    assert !Subpage.where(url: "http://localhost:3000/example/").first.content.include?("Pierwszy wpis!")
    assert !Subpage.where(url: "http://localhost:3000/example/1.html").first.content.include?("First wpis!")
  end

  test "include whole content" do
    assert Subpage.where(url: "http://localhost:3000/example/wiki.html").first.content.include?("zachowanie mające na celu wzbudzenie")
    assert Subpage.where(url: "http://localhost:3000/example/wiki.html").first.content.include?("Pojęcie seksu jest wieloznaczne, a jego znaczenie zmieniało")
    assert Subpage.where(url: "http://localhost:3000/example/wiki.html").first.content.include?("Badaniem zjawisk związanych z seksualnością człowieka zajmuje się")
  end

  test "inlcude images" do
    assert Subpage.where(url: "http://localhost:3000/example/1.html").first.content.include?("<img src=")
  end

  test "pages which are not html are not valid" do
    assert Subpage.where(url: "http://localhost:3000/example/img.jpg").first.valid_page == false
  end

  test "pages which are not found are stored but not valid" do
    assert Subpage.where(url: "http://localhost:3000/example/dupamaryni.html").first.valid_page == false
  end
   
  test "set as invalid pages with content which is duplicate of another article" do
    assert Subpage.where(url: "http://localhost:3000/example/").first.valid_page == false
  end
     


   


end
