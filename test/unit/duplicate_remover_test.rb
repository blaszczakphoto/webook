




class DuplicateRemoverTest < ActiveSupport::TestCase

  test "only url which are in base url" do

    assert !Subpage.exists?(url: "http://localhost:3000/")

  end


end