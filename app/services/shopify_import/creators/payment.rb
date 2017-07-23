module ShopifyImport
  module Creators
    class Payment < ShopifyImport::Creators::Base
      def initialize(shopify_data_feed, spree_order)
        super(shopify_data_feed)
        @spree_order = spree_order
      end

      def save!
        Spree::Payment.transaction do
          find_or_initialize_payment
          save_payment_with_attributes
          assign_spree_payment_to_data_feed
        end
        @spree_payment.update_columns(payment_timestamps)
      end

      private

      def find_or_initialize_payment
        @spree_payment = @spree_order.payments.find_or_initialize_by(number: payment_number)
      end

      def save_payment_with_attributes
        @spree_payment.assign_attributes(payment_attributes)
        @spree_payment.save!
      end

      def assign_spree_payment_to_data_feed
        @shopify_data_feed.update(spree_object: @spree_payment)
      end

      def payment_number
        parser.payment_number
      end

      def payment_attributes
        parser.payment_attributes
      end

      def payment_timestamps
        parser.payment_timestamps
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::Transactions::BaseData.new(shopify_transaction)
      end

      def shopify_transaction
        @shopify_transaction ||= ShopifyAPI::Transaction.new(data_feed)
      end
    end
  end
end
