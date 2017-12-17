class AddParentIdToShopifyDataFeed < SpreeExtension::Migration[4.2]
  def change
    add_column :shopify_data_feeds, :parent_id, :integer
    add_index :shopify_data_feeds, :parent_id
  end
end
