require "duplicate_remover"
require "book_creator"
require "spec_helper"

describe DuplicateRemover do

  before do
    @urls = [
      "http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku/",
      "http://www.zyciejestpiekne.eu/"
    ]
  end

  it "should contain only content" do
    book = BookCreator.create(@urls)
  	subpages = DuplicateRemover.remove(book.website.subpages)
    expect(subpages.count).to eq(1)
  	expect(subpages[0].url).to eq("http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku/")
  end



end