module ShopifyImport
  module DataParsers
    module Refunds
      class BaseData
        def initialize(shopify_refund, shopify_transaction, spree_reimbursement = nil)
          @shopify_refund = shopify_refund
          @shopify_transaction = shopify_transaction
          @spree_reimbursement = spree_reimbursement
        end

        def attributes
          @attributes ||= {
            payment: payment,
            amount: @shopify_transaction.amount,
            transaction_id: @shopify_transaction.authorization,
            reason: reason,
            reimbursement: @spree_reimbursement
          }
        end

        def timestamps
          @timestamps ||= {
            created_at: @shopify_refund.created_at.to_datetime,
            updated_at: @shopify_refund.processed_at.try(:to_datetime)
          }
        end

        def payment
          @payment ||= Shopify::DataFeed.find_by(shopify_object_id: @shopify_transaction.parent_id,
                                                 shopify_object_type: 'ShopifyAPI::Transaction').try(:spree_object)
        end

        def transaction_id
          @transaction_id ||= @shopify_transaction.authorization
        end

        private

        def reason
          Spree::RefundReason.create_with(active: false).find_or_create_by(name: I18n.t(:shopify))
        end
      end
    end
  end
end
