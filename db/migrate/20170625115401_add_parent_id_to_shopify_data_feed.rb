class AddParentIdToShopifyDataFeed < ActiveRecord::Migration[5.0]
  def change
    add_column :shopify_data_feeds, :parent_id, :integer
    add_index :shopify_data_feeds, :parent_id
  end
end
