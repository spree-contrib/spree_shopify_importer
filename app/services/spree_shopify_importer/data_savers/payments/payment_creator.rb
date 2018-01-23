module SpreeShopifyImporter
  module DataSavers
    module Payments
      class PaymentCreator < BaseDataSaver
        delegate :number, :attributes, :timestamps, to: :parser

        def initialize(shopify_data_feed, spree_order)
          super(shopify_data_feed)
          @spree_order = spree_order
        end

        def create!
          Spree::Payment.transaction do
            find_or_initialize_payment
            save_payment_with_attributes
            assign_spree_payment_to_data_feed
          end
          @spree_payment.update_columns(timestamps)
        end

        private

        def find_or_initialize_payment
          @spree_payment = @spree_order.payments.find_or_initialize_by(number: number)
        end

        def save_payment_with_attributes
          @spree_payment.assign_attributes(attributes)
          @spree_payment.save!(validate: false)
        end

        def assign_spree_payment_to_data_feed
          @shopify_data_feed.update(spree_object: @spree_payment)
        end

        def parser
          @parser ||= SpreeShopifyImporter::DataParsers::Payments::BaseData.new(shopify_transaction)
        end

        def shopify_transaction
          @shopify_transaction ||= ShopifyAPI::Transaction.new(data_feed)
        end
      end
    end
  end
end
