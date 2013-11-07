# encoding: utf-8
require 'test_helper'
require 'crawler'

class SubpageTest < ActiveSupport::TestCase

  def setup
    crawler = Crawler.new("http://localhost:3000/example/")
    crawler.run
  end

  test "it has closest title just above content" do
    assert_equal "The first entry!", Subpage.where(url: "http://localhost:3000/example/").first.title
    assert_equal "First wpis!", Subpage.where(url: "http://localhost:3000/example/1.html").first.title
    assert_equal "Pierwszy wpis!", Subpage.where(url: "http://localhost:3000/example/2.html").first.title
  end

  test "content not include header" do
    assert !Subpage.where(url: "http://localhost:3000/example/").first.content.include?("The first entry!")
    assert !Subpage.where(url: "http://localhost:3000/example/").first.content.include?("Pierwszy wpis!")
    assert !Subpage.where(url: "http://localhost:3000/example/1.html").first.content.include?("First wpis!")
  end

  test "include whole content" do
    assert Subpage.where(url: "http://localhost:3000/example/").first.content.include?("Dogs barking, children squealing")
    assert Subpage.where(url: "http://localhost:3000/example/wiki.html").first.content.include?("zachowanie mające na celu wzbudzenie")
    assert Subpage.where(url: "http://localhost:3000/example/wiki.html").first.content.include?("Pojęcie seksu jest wieloznaczne, a jego znaczenie zmieniało")
    assert Subpage.where(url: "http://localhost:3000/example/wiki.html").first.content.include?("Badaniem zjawisk związanych z seksualnością człowieka zajmuje się")
  end

  test "include sub headers" do
    assert Subpage.where(url: "http://localhost:3000/example/wiki.html").first.content.include?("Kwestie terminologiczno-pojęciowe")
  end

  test "inlcude images" do
    assert Subpage.where(url: "http://localhost:3000/example/").first.content.include?("Dogs barking, children squealing")
  end
    
end
