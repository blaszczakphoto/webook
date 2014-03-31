# coding: utf-8
require "content_finder"
require "debugger"

describe ContentFinder do

	it "should contain only content" do
		html = File.open("spec/files/entry1").read
		content = ContentFinder.find(html)
		content.should include("I opened up my twitter client")
		content.should_not include("View my complete profile")
	end

	it "should contain plish chars" do
		html = File.open("spec/files/jazon_krzaki").read
		content = ContentFinder.find(html)
		content.should include("Aby zakrzywić czasoprzestrzeń")
	end


	it "should contain links inside span" do
		html = File.open("spec/files/zjp_span").read
		content = ContentFinder.find(html)
		content.should include("Byłem w Turcji")
	end



	it 'should remove all span tags' do
		html = File.open("spec/files/span_lots").read
		content.should include("Byłem w Turcji")
	end

	it "should get all headers in hitchwiki" do
		html = File.open("spec/files/hitchwiki_span/o0").read
		content = ContentFinder.find(html)
		content.should include("North towards Mrkonjic-Grad or Banja Luka")	
		content.should include("Southwest")	
	end





end