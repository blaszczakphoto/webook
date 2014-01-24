require "spec_helper"

describe SubpageCreator do

  it "should create invalid object when url is not valid" do
    subpage = SubpageCreator.create("http://www.zyciejestpiekne.eu/feed")
    subpage2 = SubpageCreator.create("http://www.zyciejestpiekne.eu/wp-content/uploads/2011/04/04mini.jpg")
    expect(subpage.valid_page).to eq(false)
    expect(subpage2.valid_page).to eq(false)
  end






end