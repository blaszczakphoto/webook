# encoding: utf-8

class BooksController < ApplicationController

	def index
		urls = [
			# "http://dokturjazon.blox.pl/2011/03/Problemy-z-czasoprzestrzenia.html",
			# "http://dokturjazon.blox.pl/html"
			"http://dokturjazon.blox.pl/html/4259841,1179650,217"
		]
		book = BookCreator.create(urls)
		@subpages = DuplicateRemover.remove(book.website.subpages)
		# @subpages = book.website.subpages


		render template: "books/standard_book.html", :layout => false
	end

	def new
		# url = "http://dokturjazon.blox.pl/"
		url = "http://zyciejestpiekne.pl/"
		puts "zaczynamy!...................."
		crawler = Crawler.new(url)
		crawler.run
		puts "*"*5 + "podstron do przerobienia:" + crawler.website.subpages.count.to_s + "*"*5
		puts "*"*5 + "zmielono. teraz czas na usuwanie duplikatów" + "*"*5
		@subpages = DuplicateRemover.remove(crawler.website.subpages)
		puts "wyświetlamy!!!!!!!!!!!................"
		# @subpages = crawler.website.subpages
		render template: "books/standard_book.html", :layout => false
	end

end
