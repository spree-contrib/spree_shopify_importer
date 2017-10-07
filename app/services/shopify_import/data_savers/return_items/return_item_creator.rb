module ShopifyImport
  module DataSavers
    module ReturnItems
      class ReturnItemCreator < BaseDataSaver
        delegate :attributes, :timestamps, to: :parser

        def initialize(shopify_refund_line_item, shopify_refund, return_authorization, inventory_unit)
          @shopify_refund_line_item = shopify_refund_line_item
          @shopify_refund = shopify_refund
          @spree_return_authorization = return_authorization
          @spree_inventory_unit = inventory_unit
        end

        def create
          Spree::ReturnItem.transaction do
            @spree_return_item = Spree::ReturnItem.new
            update_return_item
          end
          update_inventory_unit
          update_timestamps
          @spree_return_item
        end

        private

        def update_return_item
          @spree_return_item.assign_attributes(attributes)
          @spree_return_item.save(validate: false)
        end

        def update_inventory_unit
          @spree_inventory_unit.update_column(:state, :returned)
        end

        def update_timestamps
          @spree_return_item.update_columns(timestamps)
        end

        def parser
          @parser ||= ShopifyImport::DataParsers::ReturnItems::BaseData.new(
            @shopify_refund_line_item,
            @shopify_refund,
            @spree_return_authorization,
            @spree_inventory_unit
          )
        end
      end
    end
  end
end
