module ShopifyImport
  module DataParsers
    module Reimbursements
      class BaseData
        def initialize(shopify_refund, spree_customer_return, spree_order)
          @shopify_refund = shopify_refund
          @spree_customer_return = spree_customer_return
          @spree_order = spree_order
        end

        def number
          @number ||= "SRI#{@shopify_refund.id}"
        end

        def attributes
          @attributes ||= {
            reimbursement_status: :reimbursed,
            customer_return: @spree_customer_return,
            order: @spree_order,
            total: total
          }
        end

        def timestamps
          @timestamps ||= {
            created_at: @shopify_refund.created_at.to_datetime,
            updated_at: @shopify_refund.processed_at.try(:to_datetime)
          }
        end

        private

        def total
          @shopify_refund.transactions.inject(0.0) { |sum, transaction| sum + transaction.amount.to_d }
        end
      end
    end
  end
end
