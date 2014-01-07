require "content_finder"

describe ContentFinder do

  it "should contain only content" do
  	html = File.open("spec/files/entry1").read
  	content = ContentFinder.find(html)
  	content.should include("I opened up my twitter client")
  	content.should_not include("View my complete profile")
  end



end