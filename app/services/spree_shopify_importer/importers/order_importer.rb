module SpreeShopifyImporter
  module Importers
    class OrderImporter < BaseImporter
      def import!
        if (old_data_feed = find_existing_data_feed).blank?
          data_feed = create_data_feed
        else
          data_feed = update_data_feed(old_data_feed)
          clear_order_data(data_feed)
        end

        creator.new(data_feed).save!
      end

      private

      def creator
        SpreeShopifyImporter::DataSavers::Orders::OrderCreator
      end

      def clear_order_data(data_feed)
        return if (order = data_feed.spree_object).blank?

        order.bill_address.delete
        order.ship_address.delete
        order.destroy
      end

      def shopify_class
        ShopifyAPI::Product
      end
    end
  end
end
