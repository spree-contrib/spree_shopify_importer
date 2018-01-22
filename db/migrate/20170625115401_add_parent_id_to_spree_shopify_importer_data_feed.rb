class AddParentIdToSpreeShopifyImporterDataFeed < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_shopify_importer_data_feeds, :parent_id, :integer
    add_index :spree_shopify_importer_data_feeds, :parent_id
  end
end
