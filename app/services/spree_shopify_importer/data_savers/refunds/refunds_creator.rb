module SpreeShopifyImporter
  module DataSavers
    module Refunds
      class RefundsCreator < BaseDataSaver
        def initialize(shopify_refund, spree_reimbursement = nil)
          @shopify_refund = shopify_refund
          @spree_reimbursement = spree_reimbursement
        end

        def create
          @shopify_refund.transactions.each do |shopify_transaction|
            spree_refund = single_refund_creator.new(@shopify_refund,
                                                     shopify_transaction,
                                                     @spree_reimbursement).create
            spree_refunds << spree_refund
          end
          spree_refunds
        end

        private

        def spree_refunds
          @spree_refunds ||= []
        end

        def single_refund_creator
          RefundCreator
        end
      end
    end
  end
end
