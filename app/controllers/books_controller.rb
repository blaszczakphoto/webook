# encoding: utf-8

class BooksController < ApplicationController

	def index
		urls = [
			# "http://dokturjazon.blox.pl/2011/03/Problemy-z-czasoprzestrzenia.html",
			# "http://dokturjazon.blox.pl/html"
			# "http://przemek-sliwka.blog.onet.pl/2009/02/15/dlaczego-chrzescijanin-powinien-glosic-ewangelie/"
			"http://dokturjazon.blox.pl/html/4259841,1179650,217.html?4735134"
		]
		# book = BookCreator.create(urls)
		# @subpages = DuplicateRemover.remove(book.website.subpages)
		# @subpages = book.website.subpages
		@subpages =  [SubpageCreator.create(urls[0])]

		render template: "books/standard_book.html", :layout => false
	end

	def new
		# url = "http://przemek-sliwka.blog.onet.pl/"
		# url = "http://dokturjazon.blox.pl/"
		url = "http://www.gotquestions.org/Polski/"
		# url = "http://www.zyciejestpiekne.eu/"
		puts "zaczynamy!...................."


		crawler = Crawler.new(url)
		crawler.run({limit: 40})
		DuplicateRemover.remove(crawler.website.subpages)

		optimizer = CrawlerOptimizer.new(crawler.website)
		p "pierwsza optymalizacja"
		optimizer.optimize!
		crawler.run({optimizer: optimizer})

		puts "*"*5 + "podstron do przerobienia:" + crawler.website.subpages.count.to_s + "*"*5
		puts "*"*5 + "zmielono. teraz czas na usuwanie duplikatów" + "*"*5

		@subpages = DuplicateRemover.remove(crawler.website.subpages, optimizer).reverse

		puts "wyświetlamy!!!!!!!!!!!................"
		# @subpages = crawler.website.subpages
		render template: "books/standard_book.html", :layout => false
	end


	def optimize
		urls = [
			"http://dokturjazon.blox.pl/html/1310721,262146,14,15.html?8,2010",
			"http://dokturjazon.blox.pl/2010/09/Czas-zakonczyc-te-niesamowita-karuzele-ten.html"
		]
		urls = [
			"http://www.gotquestions.org/Polski/Bog-wymaga-wiary.html",
			"http://www.gotquestions.org/Polski/Bog-poslal-Jezusa-czasie.html"
		]
		book = BookCreator.create(urls)
		@subpages = DuplicateRemover.remove(book.website.subpages)
		render template: "books/standard_book.html", :layout => false


	end

	def optimize2
		urls = [
			"http://www.zyciejestpiekne.eu/page/2/",
			"http://www.zyciejestpiekne.eu/page/3/",
			"http://www.zyciejestpiekne.eu/gra-w-ktora-musisz-zagrac/",
			"http://www.zyciejestpiekne.eu/czas-spojrzec-prawdzie-w-oczy/"
		]
		book = BookCreator.create(urls)
		DuplicateRemover.remove(book.website.subpages)
		book.website.base_url = "http://www.zyciejestpiekne.eu/"
		optimizer = CrawlerOptimizer.new(book.website)
		optimizer.optimize!
		urls = [
			"http://www.zyciejestpiekne.eu/page/4/"
		]

		book.website.subpages << SubpageCreator.create(urls[0])
		@subpages = DuplicateRemover.remove(book.website.subpages, optimizer)

		render template: "books/standard_book.html", :layout => false

	end

end
