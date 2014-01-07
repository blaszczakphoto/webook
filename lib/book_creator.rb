require "debugger"

class BookCreator
	attr_accessor :website

	def self.create(urls)
		book = Book.new
		website = WebsiteCreator.create(urls)
		book.website = website
		book
	end

end