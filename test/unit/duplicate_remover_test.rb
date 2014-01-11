require "duplicate_remover"
require "book_creator"
require 'test_helper'


class DuplicateRemoverTest < ActiveSupport::TestCase

  test "should remove duplicated content" do
  	@urls = [
      "http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku/",
      "http://www.zyciejestpiekne.eu/"
    ]
    book = BookCreator.create(@urls)
  	subpages = DuplicateRemover.remove(book.website.subpages)
  
    assert_equal subpages.count, 1
    assert_equal subpages[0].url, "http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku/"

  end
end