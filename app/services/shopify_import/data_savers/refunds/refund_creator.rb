module ShopifyImport
  module DataSavers
    module Refunds
      class RefundCreator < BaseDataSaver
        delegate :attributes, :timestamps, to: :parser

        def initialize(shopify_refund, shopify_transaction, spree_reimbursement = nil)
          @shopify_refund = shopify_refund
          @shopify_transaction = shopify_transaction
          @spree_reimbursement = spree_reimbursement
        end

        def create
          skip_callback
          create_refund
          set_callback

          update_timestamps
          @spree_refund
        end

        private

        def skip_callback
          Spree::Refund.skip_callback(:create, :after, :perform!)
        end

        def create_refund
          Spree::Refund.transaction do
            @spree_refund = Spree::Refund.new
            update_spree_refund
          end
        end

        def update_spree_refund
          @spree_refund.assign_attributes(attributes)
          @spree_refund.save(validate: false)
        end

        def set_callback
          Spree::Refund.set_callback(:create, :after, :perform!)
        end

        def update_timestamps
          @spree_refund.update_columns(timestamps)
        end

        def parser
          @parser ||= ShopifyImport::DataParsers::Refunds::BaseData.new(@shopify_refund,
                                                                        @shopify_transaction,
                                                                        @spree_reimbursement)
        end
      end
    end
  end
end
