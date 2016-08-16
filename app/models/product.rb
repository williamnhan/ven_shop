class Product < ActiveRecord::Base
  has_many :order_items
  belongs_to :category
  default_scope { where(active: true) }
end
