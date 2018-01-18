module SpreeShopifyImporter
  module DataParsers
    module InventoryUnits
      class BaseData
        def initialize(shopify_line_item, spree_shipment)
          @shopify_line_item = shopify_line_item
          @spree_shipment = spree_shipment
        end

        def attributes
          @attributes ||= {
            order: order,
            variant: variant,
            line_item: line_item,
            state: inventory_unit_state
          }
        end

        def line_item
          return nil if variant.blank?

          @line_item ||= order.line_items.find_by(variant: variant)
        end

        private

        def order
          @order ||= @spree_shipment.order
        end

        def variant
          @variant ||= Shopify::DataFeed.find_by(shopify_object_type: 'ShopifyAPI::Variant',
                                                 shopify_object_id: shopify_variant_id).try(:spree_object)
        end

        def inventory_unit_state
          case @spree_shipment.state.to_sym
          when :shipped then :shipped
          else :on_hand
          end
        end

        def shopify_variant_id
          @shopify_variant_id ||= @shopify_line_item.variant_id
        end
      end
    end
  end
end
