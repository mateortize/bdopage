class Category < ActiveRecord::Base
  has_many :posts, dependent: :nullify

  def self.options_for_select
    Category.all.collect do |category|
      [category.id, category.name]      
    end
  end
end
