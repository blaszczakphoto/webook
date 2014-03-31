# coding: utf-8
require "header_finder"
require "content_finder"
require "content_cleaner"

describe ContentCleaner do

  it "should contain polish chars" do
  	html = File.open("spec/files/jazon_krzaki").read
  	html.should include("Aby zakrzywić czasoprzestrzeń")
  	html = ContentCleaner.force_utf(html)
  	html.should include("Aby zakrzywić czasoprzestrzeń")
  end

  it "should contain polish chars" do
  	html = File.open("spec/files/zjp_span").read
  	html = ContentCleaner.make_images_absolute(html, "http://www.zyciejestpiekne.eu/")

  	html.should_not include("src=\"dupa.jpg")
  	html.should include("src=\"http://www.zyciejestpiekne.eu/dupa.jpg")
  end

end