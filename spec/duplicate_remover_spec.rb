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

  it "should remove subpages which fit pattern" do
    urls = [
      "http://www.zyciejestpiekne.eu/trzeba-miec-fantazje//#disqus_thread",
      "http://www.zyciejestpiekne.eu/trzeba-miec-fantazje/",
      "http://www.zyciejestpiekne.eu/stambul-miasto-magiczne//#disqus_thread",
      "http://www.zyciejestpiekne.eu/stambul-miasto-magiczne/",
      "http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku//#disqus_thread",
      "http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku/"
    ]
    book = BookCreator.create(urls)
    book.website.base_url = "http://www.zyciejestpiekne.eu/"
    DuplicateRemover.remove(book.website.subpages)
    optimizer = CrawlerOptimizer.new(book.website)
    optimizer.optimize!

    expect(optimizer.pattern_finder.patterns.count).to eq(2)
    expect(book.website.subpages[0].valid_page).to eq(false)
    expect(book.website.subpages[1].valid_page).to eq(true)
    expect(book.website.subpages[3].valid_page).to eq(true)

    urls2 = [
      "http://www.zyciejestpiekne.eu/moje-miejsce-pracy//#disqus_thread",
      "http://www.zyciejestpiekne.eu/moje-miejsce-pracy/"
    ] 
    urls2.each {|url| s = SubpageCreator.create(url); book.website.subpages << s if s.valid_page}
    subpages = DuplicateRemover.remove(book.website.subpages, optimizer)
    expect(book.website.subpages[4].valid_page).to eq(false)
    expect(book.website.subpages[5].valid_page).to eq(true)
    expect(subpages.count).to eq(4)
  end

  it "should optimize during duplicate removing" do
    
  end


  
end