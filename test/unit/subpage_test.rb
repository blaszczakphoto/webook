# encoding: utf-8
require 'test_helper'
require 'crawler'

class SubpageTest < ActiveSupport::TestCase

  def setup
    @page = Page.create
  end

  test "it has closest title just above content" do
    urls = ["http://localhost:3000/example/", "http://localhost:3000/example/1.html", "http://localhost:3000/example/2.html"]
    @page.subpages << create_subpages_from_urls(urls)

    assert_equal "Pierwszy wpis!", @page.subpages.where(url: "http://localhost:3000/example/").first.title
    assert_equal "First wpis!", @page.subpages.where(url: "http://localhost:3000/example/1.html").first.title
    assert_equal "Pierwszy wpis!", @page.subpages.where(url: "http://localhost:3000/example/2.html").first.title
  end

  test "content not include header" do
    urls = ["http://localhost:3000/example/", "http://localhost:3000/example/1.html"]
    @page.subpages << create_subpages_from_urls(urls)
    assert !@page.subpages.where(url: "http://localhost:3000/example/").first.content.include?("The first entry!")
    assert !@page.subpages.where(url: "http://localhost:3000/example/").first.content.include?("Pierwszy wpis!")
    assert !@page.subpages.where(url: "http://localhost:3000/example/1.html").first.content.include?("First wpis!")
  end

  test "include whole content" do
    urls = ["http://localhost:3000/example/wiki.html"]
    @page.subpages << create_subpages_from_urls(urls)
    assert @page.subpages.where(url: "http://localhost:3000/example/wiki.html").first.content.include?("zachowanie mające na celu wzbudzenie")
    assert @page.subpages.where(url: "http://localhost:3000/example/wiki.html").first.content.include?("Pojęcie seksu jest wieloznaczne, a jego znaczenie zmieniało")
    assert @page.subpages.where(url: "http://localhost:3000/example/wiki.html").first.content.include?("Badaniem zjawisk związanych z seksualnością człowieka zajmuje się")
  end

  test "inlcude images" do
    urls = ["http://localhost:3000/example/1.html"]
    @page.subpages << create_subpages_from_urls(urls)
    assert @page.subpages.where(url: "http://localhost:3000/example/1.html").first.content.include?("<img src=")
  end

  test "pages which are not html are not valid" do
    urls = ["http://localhost:3000/example/img.jpg"]
    @page.subpages << create_subpages_from_urls(urls)
    assert @page.subpages.where(url: "http://localhost:3000/example/img.jpg").first.valid_page == false
  end

  test "pages which are not found are stored but not valid" do
    urls = ["http://localhost:3000/example/dupamaryni.html"]
    @page.subpages << create_subpages_from_urls(urls)
    assert @page.subpages.where(url: "http://localhost:3000/example/dupamaryni.html").first.valid_page == false
  end

  test "set as invalid pages with content which is duplicate of another article" do
    urls = [
      "http://localhost:3000/example/", 
      "http://localhost:3000/example/1.html", 
      "http://www.zyciejestpiekne.eu/", 
      "http://www.zyciejestpiekne.eu/20-powodow-za-ktore-uwielbiam-krakow/",
      "http://www.loswiaheros.pl/australia",
      "http://www.loswiaheros.pl/australia/667-aborygeni-ostatni-koczownicy"
    ]

      @page.subpages << create_subpages_from_urls(urls)
      @page.subpages.remove_duplicates!
      

      assert @page.subpages.where(url: "http://localhost:3000/example/").first.valid_page == false
      assert @page.subpages.where(url: "http://localhost:3000/example/1.html").first.valid_page == true
      assert @page.subpages.where(url: "http://www.zyciejestpiekne.eu/").first.valid_page == false
      assert @page.subpages.where(url: "http://www.zyciejestpiekne.eu/20-powodow-za-ktore-uwielbiam-krakow/").first.valid_page == true
      assert @page.subpages.where(url: "http://www.loswiaheros.pl/australia").first.valid_page == false
      assert @page.subpages.where(url: "http://www.loswiaheros.pl/australia/667-aborygeni-ostatni-koczownicy").first.valid_page == true
    end

    test "set as invalid if has extension url is not valid" do
      urls = ["http://localhost:3000/example/img.jpg"]
      @page.subpages << create_subpages_from_urls(urls)
      assert @page.subpages.where(url: "http://localhost:3000/example/img.jpg").first.valid_page == false
    end


    test "subpage has uniq similar subpages" do
      urls = ["http://www.blankwebsite.com/",
              "http://www.blankwebsite.com/"
              ]

      @page.subpages << create_subpages_from_urls(urls)
      @page.subpages.first.similar_subpages << @page.subpages.last
      @page.subpages.first.similar_subpages << @page.subpages.last
      @page.subpages.last.similar_subpages << @page.subpages.first
      assert @page.subpages.first.similar_subpages.first == @page.subpages.last
      assert_equal 1, @page.subpages.first.similar_subpages.count
      assert @page.subpages.last.similar_subpages.first == @page.subpages.first
    end






end
