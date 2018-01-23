module SpreeShopifyImporter
  module DataSavers
    module Reimbursements
      class ReimbursementCreator
        delegate :number, :attributes, :timestamps, to: :parser

        def initialize(shopify_refund, spree_customer_return, spree_order)
          @shopify_refund = shopify_refund
          @spree_customer_return = spree_customer_return
          @spree_order = spree_order
        end

        def create
          Spree::Reimbursement.transaction do
            @spree_reimbursement = Spree::Reimbursement.first_or_initialize(number: number)
            update_spree_reimbursement
          end
          assign_return_items
          update_timestamps
          @spree_reimbursement
        end

        private

        def update_spree_reimbursement
          @spree_reimbursement.assign_attributes(attributes)
          @spree_reimbursement.save(validate: false)
        end

        def assign_return_items
          @spree_customer_return.return_items.update_all(reimbursement_id: @spree_reimbursement.id)
        end

        def update_timestamps
          @spree_reimbursement.update_columns(timestamps)
        end

        def parser
          @parser ||= SpreeShopifyImporter::DataParsers::Reimbursements::BaseData.new(@shopify_refund,
                                                                                      @spree_customer_return,
                                                                                      @spree_order)
        end
      end
    end
  end
end
