module ShopifyImport
  module DataParsers
    module Adjustments
      module Tax
        class BaseData
          def initialize(shopify_tax_line, spree_order, spree_tax_rate)
            @shopify_tax_line = shopify_tax_line
            @spree_order = spree_order
            @spree_tax_rate = spree_tax_rate
          end

          def adjustment_attributes
            {
              order: @spree_order,
              adjustable: @spree_order,
              label: @shopify_tax_line.title,
              source: @spree_tax_rate,
              amount: @shopify_tax_line.price,
              state: :closed
            }
          end
        end
      end
    end
  end
end
