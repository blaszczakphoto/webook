

class Subpage < ActiveRecord::Base
  before_create :default_values
  belongs_to :website

  has_many :similar_subpages_association, :class_name => "SimilarSubpage"
  has_many :similar_subpages, :through => :similar_subpages_association, :uniq => true

  attr_accessible :title, :url, :datetime, :content, :valid_page, :website, :similar_subpages, :html

  scope :valid_pages, -> { where(valid_page: true) }

  def default_values
    self.valid_page = true if self.valid_page.nil?
  end


  def self.create_invalid(url)
    Subpage.create(url: url, valid_page: false)
  end
  
  def clean_content
    Sanitize.clean(content).gsub("\n","").strip
  end

  


end