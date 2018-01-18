module SpreeShopifyImporter
  module DataSavers
    module Adjustments
      class TaxCreator
        delegate :attributes, to: :parser

        def initialize(shopify_tax_line, spree_order, spree_tax_rate)
          @shopify_tax_line = shopify_tax_line
          @spree_order = spree_order
          @spree_tax_rate = spree_tax_rate
        end

        def create!
          Spree::Adjustment.transaction do
            @spree_order.adjustments.create!(attributes)
          end
        end

        private

        def parser
          @parser ||= SpreeShopifyImporter::DataParsers::Adjustments::Tax::BaseData.new(@shopify_tax_line,
                                                                                        @spree_order,
                                                                                        @spree_tax_rate)
        end
      end
    end
  end
end
