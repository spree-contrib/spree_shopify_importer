module ShopifyImport
  module DataParsers
    module LineItems
      class BaseData
        def initialize(shopify_line_item, shopify_order)
          @shopify_line_item = shopify_line_item
          @shopify_order = shopify_order
        end

        def line_item_attributes
          {
            quantity: @shopify_line_item.quantity,
            price: @shopify_line_item.price,
            currency: @shopify_order.currency,
            adjustment_total: - @shopify_line_item.total_discount.to_d
          }
        end

        # TODO: Product not imported or variant not found
        def variant
          return nil if (variant_id = @shopify_line_item.variant_id).blank?

          Shopify::DataFeed
            .find_by(shopify_object_type: 'ShopifyAPI::Variant', shopify_object_id: variant_id)
            .try(:spree_object)
        end
      end
    end
  end
end
