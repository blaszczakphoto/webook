require "duplicate_remover"
require "book_creator"



class DuplicateRemoverTest < ActiveSupport::TestCase

  test "should find duplicated content" do
  	html1 = File.open("spec/files/danwit_home").read
    html2 = File.open("spec/files/danwit_glukoza").read
    assert_equal DuplicateRemover.is_duplicate?(html1, html2), true
  end


end