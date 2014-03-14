# coding: utf-8
require "crawler_optimizer"
require "debugger"

describe CrawlerOptimizer do
	before(:each) do
		@urls = [
			"http://www.dupa.pl/kategorie/robert/",
			"http://www.dupa.pl/kategorie/fdasyrtyrfascd/",
			"http://www.dupa.pl/robertkwasnik//#disqus_thread",
			"http://www.dupa.pl/czarek-kwasnikiewicz//#disqus_thread",

			"http://www.dupa.pl/1310721,262146,169.html?2",
			"http://www.dupa.pl/1310721,262146,169.html?3",
			"http://www.dupa.pl/1310721,262146,169.html?4",
			"http://www.dupa.pl/1310721,262146,169.html?5",
			"http://www.dupa.pl/4259841,1179650,217.html?5402227",
			"http://www.dupa.pl/2011/03/Dwie-strony-rzeki-i-medalu.rss",
			"http://www.dupa.pl/4259841,1179650,217.html?5395412",
			"http://www.dupa.pl/2011/03/Problemy-z-czasoprzestrzenia.rss",
			"http://www.dupa.pl/4259841,1179650,217.html?4904359",
			"http://www.dupa.pl/2010/09/Czas-zakonczyc-te-niesamowita-karuzele-ten.rss",
			"http://www.dupa.pl/4259841,1179650,217.html?4803414",
			"http://www.dupa.pl/2010/07/Cisza-spokoj-gory.rss",
			"http://www.dupa.pl/4259841,1179650,217.html?4769546",
			"http://www.dupa.pl/2010/07/Wyprawa-zlodzieja-do-Mazeri.rss",
			"http://www.dupa.pl/4259841,1179650,217.html?4766930",
			"http://www.dupa.pl/2010/07/Garsc-zasad.rss",
			"http://www.dupa.pl/4259841,1179650,217.html?4755618",
			"http://www.dupa.pl/2010/06/Latajaca-marszrutka.rss",
			"http://www.dupa.pl/4259841,1179650,217.html?4735134",
			"http://www.dupa.pl/2010/06/Leniwa-niedziela-w-sloncu.rss",
			"http://www.dupa.pl/1310721,262146,14,15.html?2,2011",
			"http://www.dupa.pl/4259841,1179650,217.html?4718534",
			"http://www.dupa.pl/1310721,262146,14,15.html?6,2010",
			"http://www.dupa.pl/1310721,262146,14,15.html?5,2010",
 			"http://www.dupa.pl/1310721,262146,169,170.html?1,1",
 "http://www.dupa.pl/1310721,262146,14,15.html?1,2010",
"http://www.dupa.pl/1310721,262146,14,15.html?3,2010",
 "http://www.dupa.pl/1310721,262146,169.html?3",
"http://www.dupa.pl/2010/05/Niedziela.html",
"http://www.dupa.pl/2011/03/Problemy-z-czasoprzestrzenia.html",
"http://www.dupa.pl/1310721,262146,14,15.html?8,2010"
		]

		@v_urls = [
			"http://www.dupa.pl/fdasfasd/",
			"http://www.dupa.pl/marcin/",
			"http://www.dupa.pl/grzessda/",
			"http://www.dupa.pl/dupa-blada/",
			"http://www.dupa.pl/myszka-miki/",
			"http://www.dupa.pl/2011/03/Dwie-strony-rzeki-i-medalu.html",
			"http://www.dupa.pl/1310721,262146,14,15.html?4,2010"
		]

		@website = double("website")
		@website.stub(:base_url) {"http://www.dupa.pl/"}

		subpages = []
		@urls.each {|url| s = double("subpage"); s.stub(:url) {url}; s.stub(:links_num) {0}; s.stub(:valid_page) {false}; subpages.push(s)}
		@v_urls.each {|url| s = double("subpage"); s.stub(:url) {url}; s.stub(:valid_page) {true}; s.stub(:links_num) {0}; subpages.push(s)}

		@website.stub(:subpages) {subpages}

		@optimizer = CrawlerOptimizer.new(@website)
		@optimizer.optimize!
	end

	it "should find all patterns"do
		expect(@optimizer.pattern?("http://www.dupa.pl/kategorie/fdasfasd/")).to eq(true)
		expect(@optimizer.pattern?("http://www.dupa.pl/fdasfasd//#disqus_thread")).to eq(true)
		expect(@optimizer.pattern?("http://www.dupa.pl/4259841,1179650,217.html?4718534")).to eq(true)
		expect(@optimizer.pattern?("http://www.dupa.pl/1310721,262146,14,15.html?2,2011")).to eq(true)
	end


end