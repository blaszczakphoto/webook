# encoding: utf-8

class BooksController < ApplicationController


	def index
		urls = [
			
			"http://zkobietamudotwarzy.blogspot.com.es/2012/11/piepszona-pewnosc-siebie.html"

		]
		book = BookCreator.create(urls)
		@subpages = DuplicateRemover.remove(book.website.subpages)
		render template: "books/standard_book.html", :layout => false
	end

end
