require "duplicate_remover"
require "book_creator"
require "subpage_creator"

describe DuplicateRemover do
  it "should find all duplicates" do
    # html1 = File.open("spec/files/danwit_dlaczego").read
    html1 = File.open("spec/files/danwit_home").read
    html2 = File.open("spec/files/danwit_glukoza").read
    expect(DuplicateRemover.is_duplicate?(html1, html2)).to eq(true)
  end

end