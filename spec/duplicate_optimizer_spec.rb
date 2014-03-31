# coding: utf-8
require "duplicate_remover"
require "book_creator"
require "spec_helper_light"
require "duplicate_optimizer"

describe DuplicateRemover do
  include HelpersLight

  it "should obtain most of the patterns in first 100 elements" do




    subpages = []
    subpages += create_subpages(@urls_o, "spec/files/linielotnicze_duplicate/o", {valid_page: true, links_num: 3})
    @website = create_website(base_url: "http://linielotnicze.blox.pl/", subpages: subpages)
    @duplicate_remover = DuplicateRemover.new(@website)
    @subpages = @duplicate_remover.remove

    p " "
    expect(@subpages.count).to eq(1)
    expect(@subpages.map{|x| x.url}).to include("http://linielotnicze.blox.pl/2014/02/Holly-i-Graham.html")
    expect(@subpages.map{|x| x.url}).should_not include("http://linielotnicze.blox.pl/")
  end


end