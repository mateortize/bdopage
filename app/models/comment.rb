class Comment < ActiveRecord::Base
  has_many :children, class_name: "Comment", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Comment"

  belongs_to :post
  belongs_to :commenter, class_name: "Account", foreign_key: "account_id"
end
