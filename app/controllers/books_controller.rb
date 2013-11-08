require 'crawler'

class BooksController < ApplicationController


  def index
    #url = "http://localhost:3000/example/"
    Page.all.each {|a| a.destroy}
    Subpage.all.each {|a| a.destroy}

    url = "http://www.chrissupertramp.pl/"
    crawler = Crawler.new(url)
    crawler.run

    @page = crawler.page
    
    render template: "books/standard_book", :layout => false
  end


end
