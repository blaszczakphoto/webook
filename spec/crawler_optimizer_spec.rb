# coding: utf-8
require "crawler_optimizer"
require "debugger"

describe CrawlerOptimizer do
	before(:each) do
		@urls = [
			"http://www.dupa.pl/kategorie/robert/",
			"http://www.dupa.pl/kategorie/fdasyrtyrfascd/",
			"http://www.dupa.pl/robertkwasnik//#disqus_thread",
			"http://www.dupa.pl/czarek-kwasnikiewicz//#disqus_thread"
		]

		@v_urls = [
			"http://www.dupa.pl/fdasfasd/",
			"http://www.dupa.pl/marcin/",
			"http://www.dupa.pl/grzessda/",
			"http://www.dupa.pl/dupa-blada/",
			"http://www.dupa.pl/myszka-miki/"
		]

		@website = double("website")
		@website.stub(:base_url) {"http://www.dupa.pl/"}

		subpages = []
		@urls.each {|url| s = double("subpage"); s.stub(:url) {url}; s.stub(:valid_page) {false}; subpages.push(s)}
		@v_urls.each {|url| s = double("subpage"); s.stub(:url) {url}; s.stub(:valid_page) {true}; subpages.push(s)}

		@website.stub(:subpages) {subpages}

		@optimizer = CrawlerOptimizer.new(@website)
		@optimizer.optimize!
	end

	it "should find all patterns" do
		expect(@optimizer.pattern_finder.has_pattern?("http://www.dupa.pl/fdasfasd//#disqus_thread")).to eq(true)
		expect(@optimizer.pattern_finder.has_pattern?("http://www.dupa.pl/kategorie/fdasfasd/")).to eq(true)
	end

end