class SimilarSubpage < ActiveRecord::Base
  belongs_to :subpage
  belongs_to :similar_subpage, :class_name => 'Subpage'
end

