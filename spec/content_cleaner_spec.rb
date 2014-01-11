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

end