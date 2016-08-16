class AddColumnsToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :url, :string
    add_column :products, :feature, :string
    add_column :products, :image_url, :string
    add_column :products, :link, :string
    add_column :products, :asin, :string
    add_column :products, :category_id, :string
  end
end
