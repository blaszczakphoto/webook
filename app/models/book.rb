class Book < ActiveRecord::Base
  attr_accessible :content, :page
  has_one :page

  def self.create_from_page(page)
    book = Book.new
    book.page = page
    book.content = create_layout(book.page.subpages)
    book.save
    book
  end

  def self.create_layout(subpages)
    content = ""
    subpages.each do |subpage|
      #binding.pry
      content += "<h2>#{subpage.title}</h2>"
      content += subpage.content
      content += "</br></br></br>"
    end
    content
  end

  def to_html
    self.content
  end



end
