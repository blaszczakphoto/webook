require "spec_helper"

describe SubpageCreator do

  it "should create invalid object when url is not valid" do
    subpage = SubpageCreator.create("http://www.zyciejestpiekne.eu/feed")
    expect(subpage.valid_page).to eq(false)
  end






end