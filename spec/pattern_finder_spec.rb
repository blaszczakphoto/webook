# coding: utf-8
require "pattern_finder"
require "debugger"

describe PatternFinder do

	before(:each) do
		@urls = [
			"http://www.dupa.pl/kategorie/robert/",
			"http://www.dupa.pl/kategorie/fdasyrtyrfascd/",
			"http://www.dupa.pl/robertkwasnik//#disqus_thread",
			"http://www.dupa.pl/czarek-kwasnikiewicz//#disqus_thread"
		]

		@v_urls = [
			"http://www.dupa.pl/fdasfasd/",
			"http://www.dupa.pl/fdasyrtyrfascd/"
		]

		@website = double("website")
		@website.stub(:base_url) {"http://www.dupa.pl/"}

		subpages = []
		@urls.each {|url| s = double("subpage"); s.stub(:url) {url}; s.stub(:links_num) {0}; s.stub(:valid_page) {false}; subpages.push(s)}
		@v_urls.each {|url| s = double("subpage"); s.stub(:url) {url}; s.stub(:links_num) {0}; s.stub(:valid_page) {true}; subpages.push(s)}

		@website.stub(:subpages) {subpages}

		@pattern_finder = PatternFinder.new(@website)
		@pattern_finder.find([@urls[0],@urls[1]])
		@pattern_finder.find([@urls[2],@urls[3]])

	end

	it "should create working pattern" do
		pattern = @pattern_finder.create_pattern("kategorie/", ["http://www.dupa.pl/kategorie/"])
		expect(@urls[0] =~ pattern).to eq(0)
	end


	it "should find pattern in the beginning" do
		expect(@urls[0] =~ @pattern_finder.patterns[0]).to eq(0)
		expect(@urls[1] =~ @pattern_finder.patterns[0]).to eq(0)
	end

	it "should check if url has pattern" do
		expect(@pattern_finder.has_pattern?(@urls[0])).to eq(true)
		expect(@pattern_finder.has_pattern?(@v_urls[0])).to eq(false)
	end

	it "should create pattern working in the end" do
		urls = ["http://www.zyciejestpiekne.eu/7-rzeczy-ktore-zczesliwym//#disqus_thread"]
		pattern = @pattern_finder.create_pattern("//#disqus_thread", urls)
		expect(("http://www.zyciejestpiekne.eu/7-rzeczy-ktore-zczesliwym//#disqus_thread" =~ pattern) > 0).to eq(true)
		expect(("//#disqus_threadhttp://www.zyciejestpiekne.eu/7-rzeczzesliwym" =~ pattern).nil?).to eq(true)
		expect(("http://www.zyciejestpiekn//#disqus_threade.eu/7-rzeczzesliwym" =~ pattern).nil?).to eq(true)
	end

	it "should find pattern in the end" do
		expect(@pattern_finder.has_pattern?(@urls[2])).to eq(true)
		expect(@pattern_finder.has_pattern?(@urls[3])).to eq(true)
	end








end