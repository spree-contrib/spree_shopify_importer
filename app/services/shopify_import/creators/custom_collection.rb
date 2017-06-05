module ShopifyImport
  module Creators
    class CustomCollection
      def initialize(shopify_data_feed)
        @shopify_data_feed = shopify_data_feed
      end

      def save!
        Spree::Taxon.transaction do
          @spree_taxon = create_spree_taxon
          add_products
          assign_spree_taxon_to_data_feed
        end
      end

      private

      def create_spree_taxon
        Spree::Taxon
          .create_with(taxon_attributes.merge(parent: taxonomy.root))
          .find_or_create_by(taxonomy: taxonomy, name: taxon_attributes[:name])
      end

      def add_products
        @spree_taxon.update!(product_ids: product_ids)
      end

      def assign_spree_taxon_to_data_feed
        @shopify_data_feed.update!(spree_object: @spree_taxon)
      end

      def taxonomy
        @taxonomy ||= Spree::Taxonomy.find_or_create_by(name: I18n.t(:shopify_custom_collections))
      end

      def taxon_attributes
        @taxon_attributes ||= parser.taxon_attributes
      end

      def product_ids
        @product_ids ||= @parser.product_ids
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::CustomCollections::BaseData.new(shopify_custom_collection)
      end

      def shopify_custom_collection
        @shopify_custom_collection ||= ShopifyAPI::CustomCollection.new(JSON.parse(@shopify_data_feed.data_feed))
      end
    end
  end
end
