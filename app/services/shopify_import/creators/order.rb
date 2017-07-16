module ShopifyImport
  module Creators
    class Order < ShopifyImport::Creators::Base
      def save!
        Spree::Order.transaction do
          @spree_order = create_spree_order
          assign_spree_order_to_data_feed
          create_spree_line_items
          create_spree_payments
          # TODO: shipments
          # TODO: taxes
          # TODO: promotions
          # TODO: refunds
          # TODO: addresses
        end
        @spree_order.update_columns(order_timestamps)
      end

      private

      def create_spree_order
        order = Spree::Order.new(user: user)
        order.assign_attributes(order_attributes)
        order.save!
        order
      end

      def create_spree_line_items
        shopify_order.line_items.each do |shopify_line_item|
          ShopifyImport::Creators::LineItem.new(shopify_line_item, shopify_order, @spree_order).save
        end
      end

      def create_spree_payments
        transactions = shopify_order.transactions.reject { |t| t.kind.eql?('refund') }

        # TODO: to verify
        if children_transactions?(transactions)
          ids = transactions.map(&:id)

          transactions.each do |t|
            check_transaction_is_not_duplicate?(ids, t) && create_spree_payment(t)
          end
        else
          transactions.each { |t| create_spree_payment(t) }
        end
      end

      def check_transaction_is_not_duplicate?(ids, t)
        (!t.kind.eql?('authorization') && ids.include?(t.parent_id))
      end

      def children_transactions?(transactions)
        check_transactions_kinds?(transactions) && check_transactions_parents?(transactions)
      end

      def check_transactions_kinds?(transactions)
        kinds = transactions.map(&:kind)

        kinds.include?('authorization') && kinds.include?('capture')
      end

      def check_transactions_parents?(transactions)
        ids = transactions.map(&:id)
        parent_ids = transactions.map(&:parent_id)

        (parent_ids - ids).compact.empty?
      end

      def create_spree_payment(transaction)
        transaction_data_feed = Shopify::DataFeeds::Create.new(transaction, @shopify_data_feed).save!
        ShopifyImport::Creators::Transaction.new(transaction_data_feed, @spree_order).save!
      end

      def user
        parser.user
      end

      def order_attributes
        parser.order_attributes.select { |a| Spree::Order.attribute_method?(a) }
      end

      def order_timestamps
        parser.order_timestamps
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::Orders::BaseData.new(shopify_order)
      end

      def shopify_order
        @shopify_order ||= ShopifyAPI::Order.new(data_feed)
      end

      def assign_spree_order_to_data_feed
        @shopify_data_feed.update!(spree_object: @spree_order)
      end
    end
  end
end
