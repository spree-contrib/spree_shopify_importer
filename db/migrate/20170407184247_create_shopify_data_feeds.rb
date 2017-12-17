class CreateShopifyDataFeeds < SpreeExtension::Migration[4.2]
  def change
    create_table :shopify_data_feeds do |t|
      t.integer :shopify_object_id, limit: 8, null: false
      t.string :shopify_object_type, null: false
      t.integer :spree_object_id
      t.string :spree_object_type
      t.text :data_feed
      t.timestamps
    end

    add_index :shopify_data_feeds, [:shopify_object_id, :shopify_object_type],
              name: 'index_shopify_object_id_shopify_object_type', unique: true
    add_index :shopify_data_feeds, [:spree_object_id, :spree_object_type],
              name: 'index_spree_object_id_spree_object_type', unique: true
  end
end
