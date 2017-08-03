module ShopifyImport
  module Creators
    module Adjustments
      class TaxCreator
        def initialize(shopify_tax_line, spree_order, spree_tax_rate)
          @shopify_tax_line = shopify_tax_line
          @spree_order = spree_order
          @spree_tax_rate = spree_tax_rate
        end

        def save!
          Spree::Adjustment.transaction do
            @spree_order.adjustments.create!(adjustment_attributes)
          end
        end

        private

        def adjustment_attributes
          @adjustment_attributes ||= parser.adjustment_attributes
        end

        def parser
          @parser ||= ShopifyImport::DataParsers::Adjustments::Tax::BaseData.new(@shopify_tax_line,
                                                                                 @spree_order,
                                                                                 @spree_tax_rate)
        end
      end
    end
  end
end
