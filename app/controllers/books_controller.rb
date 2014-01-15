# encoding: utf-8

class BooksController < ApplicationController

	def index
		urls = [
			# "http://dokturjazon.blox.pl/2011/03/Problemy-z-czasoprzestrzenia.html",
			# "http://dokturjazon.blox.pl/html"
			"http://przemek-sliwka.blog.onet.pl/2009/02/15/dlaczego-chrzescijanin-powinien-glosic-ewangelie/"
		]
		book = BookCreator.create(urls)
		@subpages = DuplicateRemover.remove(book.website.subpages)
		# @subpages = book.website.subpages


		render template: "books/standard_book.html", :layout => false
	end

	def new
		url = "http://przemek-sliwka.blog.onet.pl/"
		# url = "http://www.zyciejestpiekne.eu/"
		puts "zaczynamy!...................."


		crawler = Crawler.new(url)
		crawler.run({limit: 20})
		DuplicateRemover.remove(crawler.website.subpages)
		optimizer = CrawlerOptimizer.new(crawler.website)

		optimizer.optimize!
		crawler.run({limit: 100, optimizer: optimizer})
		DuplicateRemover.remove(crawler.website)
		optimizer.optimize!
		crawler.run({limit: 500, optimizer: optimizer})
		DuplicateRemover.remove(crawler.website)
		optimizer.optimize!
		crawler.run({optimizer: optimizer})

		puts "*"*5 + "podstron do przerobienia:" + crawler.website.subpages.count.to_s + "*"*5
		puts "*"*5 + "zmielono. teraz czas na usuwanie duplikatów" + "*"*5


		@subpages = DuplicateRemover.remove(crawler.website.subpages)


		puts "wyświetlamy!!!!!!!!!!!................"


		# @subpages = crawler.website.subpages
		render template: "books/standard_book.html", :layout => false
	end


	def optimize
		urls = [
			"http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku/",
			"http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku//#disqus_thread",
			"http://www.zyciejestpiekne.eu/stambul-miasto-magiczne//#disqus_thread",
			"http://www.zyciejestpiekne.eu/stambul-miasto-magiczne"
		]
		book = BookCreator.create(urls)
		DuplicateRemover.remove(book.website.subpages)
		book.website.base_url = "http://www.zyciejestpiekne.eu/"
		optimizer = CrawlerOptimizer.new(book.website)
		optimizer.optimize!
		debugger

		
		@subpages = DuplicateRemover.remove(book.website.subpages)
		render template: "books/standard_book.html", :layout => false

	end

end
