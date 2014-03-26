require "book_creator"
require "image_downloader"
require "kindlegen"

class MobiCreator

	def initialize(subpages, title)
		@subpages =subpages
		@title = title
		@ac = ActionController::Base.new()
	end

	# Create mobi ebook from subpage objects
	# 
	def create
		FileUtils.makedirs(dir_name) unless File.exists?(dir_name)

		image_downloader = ImageDownloader.new(text, dir_name)
		changed_text = image_downloader.download

		File.open("#{dir_name}/text.html", 'w') {|f| f.write(changed_text)}
		File.open("#{dir_name}/toc.html", 'w') {|f| f.write(toc)}
		File.open("#{dir_name}/book.opf", 'w') {|f| f.write(book_opf)}
		FileUtils.cp("#{Rails.root}/public/books/hitchwiki/toc.ncx", "#{dir_name}/toc.ncx")
		Kindlegen.run("#{dir_name}/book.opf", "-o", "#{mobi_filename}.mobi")

		return ["#{dir_name}/#{mobi_filename}.mobi", dir_name]
	end


	def sanitize_filename(filename)
		fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m
		fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }
		return fn.join '.'
	end

	# Dir has a random name
	# 
	def dir_name
		@dir_name ||= "#{Rails.root}/public/books/%s" % (0...8).map { (65 + rand(26)).chr }.join
	end

	# File name after sanitizing
	def mobi_filename
		@mobi_filename ||= sanitize_filename(@title)
	end

	# Table of contents html string
	def toc
		@toc ||= create_string("standard_toc")
	end

	# Mobi config file string
	def book_opf
		@book_opf ||= create_string("book")
	end

	# Main body html string
	def text
		@text ||= create_string("standard_book")
	end

	# Creates string from any partial inside books
	def create_string(partial)
		@ac.render_to_string(
			:partial => "books/#{partial}.html", 
			:locals => {:@subpages => @subpages, :@title => @title})
	end



end