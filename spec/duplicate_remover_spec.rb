require "duplicate_remover"
require "book_creator"
require "spec_helper"

describe DuplicateRemover do

  before do
    @urls = [
      "http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku/",
      "http://www.zyciejestpiekne.eu/"
    ]

    @urls2 = [
      "http://www.danwit.pl/artykuly/glukozamina-a-stany-zapalne-stawow/",
      "http://www.danwit.pl/artykuly/dlaczego-apetyt-rosnie-w-miare-jedzenia/",
      "http://www.danwit.pl/artykuly/dlaczego-bywamy-glodni/",
      "http://www.danwit.pl/artykuly/"
    ]
  end

  it "should contain only content" do
    book = BookCreator.create(@urls)
    subpages = DuplicateRemover.remove(book.website.subpages)
    expect(subpages.count).to eq(1)
    expect(subpages[0].url).to eq("http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku/")
  end

  it "should contain all original articles" do
    book = BookCreator.create(@urls2)
    subpages = DuplicateRemover.remove(book.website.subpages)
    expect(subpages.count).to eq(3)
    expect(subpages[0].url).to eq("http://www.danwit.pl/artykuly/glukozamina-a-stany-zapalne-stawow/")
    expect(subpages[1].url).to eq("http://www.danwit.pl/artykuly/dlaczego-apetyt-rosnie-w-miare-jedzenia/")
  end





end