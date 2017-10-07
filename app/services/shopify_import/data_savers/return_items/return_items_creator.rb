# TODO: move dummy shipment creation to another class
# TODO: move new inventory units creation to another class

module ShopifyImport
  module DataSavers
    module ReturnItems
      class ReturnItemsCreator < BaseDataSaver
        def initialize(shopify_refund_line_item, shopify_refund, spree_return_authorization, spree_order)
          @shopify_refund_line_item = shopify_refund_line_item
          @shopify_refund = shopify_refund
          @spree_return_authorization = spree_return_authorization
          @spree_order = spree_order
        end

        def create
          @shopify_refund_line_item.quantity.times do |n|
            spree_return_item = single_item_creator.new(@shopify_refund_line_item,
                                                        @shopify_refund,
                                                        @spree_return_authorization,
                                                        inventory_unit(n)).create
            spree_return_items << spree_return_item
          end
          spree_return_items
        end

        private

        def inventory_unit(n)
          existing_inventory_unit(n).presence || new_inventory_unit
        end

        def existing_inventory_unit(n)
          Spree::InventoryUnit
            .joins(:variant)
            .where(order_id: @spree_order.id, spree_variants: { id: variant.id })[n]
        end

        def new_inventory_unit
          shipment = @spree_order.shipments.first.presence || create_dummy_shipment
          line_item = @spree_order.line_items.joins(:variant).where(spree_variants:
                                                                      { id: variant.id }).first

          inventory_unit = create_inventor_unit(line_item, shipment)
          shipment.line_items << line_item
          inventory_unit
        end

        def create_inventor_unit(line_item, shipment)
          shipment.inventory_units.create!(variant: variant, order: @spree_order, line_item: line_item)
        end

        def create_dummy_shipment
          shipment = @spree_order.shipments.create_with(shipment_attributes).find_or_initialize_by(
            number: @shopify_refund.id
          )
          shipment.save(validate: false)
          shipment
        end

        def shipment_attributes
          {
            stock_location: stock_location,
            state: :canceled,
            created_at: @shopify_refund.created_at,
            updated_at: @shopify_refund.processed_at
          }
        end

        def stock_location
          Spree::StockLocation.find_by(name: I18n.t(:shopify))
        end

        def variant
          @variant ||= Shopify::DataFeed.find_by(shopify_object_type: 'ShopifyAPI::Variant',
                                                 shopify_object_id: variant_id).try(:spree_object)
        end

        def variant_id
          @shopify_refund_line_item.line_item.variant_id
        end

        def spree_return_items
          @spree_return_items ||= []
        end

        def single_item_creator
          ReturnItemCreator
        end
      end
    end
  end
end
