module SpreeShopifyImporter
  module DataSavers
    module Taxons
      class TaxonCreator < TaxonBase
        def create!
          Spree::Taxon.transaction do
            create_spree_taxon
            add_products
            assign_spree_taxon_to_data_feed
          end
        end

        private

        def create_spree_taxon
          @spree_taxon = Spree::Taxon.create!(attributes.merge(parent: taxonomy.root))
        end
      end
    end
  end
end
