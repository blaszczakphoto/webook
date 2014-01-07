# coding: utf-8
require "header_finder"
require "content_finder"

describe HeaderFinder do

  it "should contain only header" do
  	html = File.open("spec/files/entry2").read
  	content = ContentFinder.find(html)
  	header = HeaderFinder.find(html, content)
  	header.should include("Niech to co niemożliwe dzisiaj, będzie możliwością jutro!")
  	header.should_not include("Niech to co niemożliwe dzisiaj, będzie możliwością wczoraj!")
  	header.should_not include("Opublikowano")
  end

end