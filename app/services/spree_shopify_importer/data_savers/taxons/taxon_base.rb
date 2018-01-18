module SpreeShopifyImporter
  module DataSavers
    module Taxons
      class TaxonBase < BaseDataSaver
        delegate :attributes, :product_ids, :taxonomy, to: :parser

        private

        def add_products
          @spree_taxon.update!(product_ids: product_ids)
        end

        def assign_spree_taxon_to_data_feed
          @shopify_data_feed.update!(spree_object: @spree_taxon)
        end

        def parser
          @parser ||= SpreeShopifyImporter::DataParsers::Taxons::BaseData.new(shopify_custom_collection)
        end

        def shopify_custom_collection
          @shopify_custom_collection ||= ShopifyAPI::CustomCollection.new(data_feed)
        end
      end
    end
  end
end
