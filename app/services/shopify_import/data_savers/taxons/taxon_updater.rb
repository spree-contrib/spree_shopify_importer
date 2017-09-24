module ShopifyImport
  module DataSavers
    module Taxons
      class TaxonUpdater < TaxonBase
        def initialize(shopify_data_feed, spree_taxon)
          @shopify_data_feed = shopify_data_feed
          @spree_taxon = spree_taxon
        end

        def update!
          Spree::Taxon.transaction do
            update_spree_taxon
            add_products
          end
        end

        private

        def update_spree_taxon
          @spree_taxon.update!(attributes.merge(parent: taxonomy.root))
        end
      end
    end
  end
end
