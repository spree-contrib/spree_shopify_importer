module SpreeShopifyImporter
  module DataSavers
    module CustomerReturns
      class CustomerReturnCreator < BaseDataSaver
        delegate :number, :attributes, :timestamps, to: :parser

        def initialize(shopify_refund, return_items = [])
          @shopify_refund = shopify_refund
          @return_items = return_items
        end

        def create
          skip_callbacks
          create_customer_return
          set_callbacks
          update_timestamps
          assign_return_items

          @customer_return
        end

        private

        def skip_callbacks
          Spree::CustomerReturn.skip_callback(:create, :after, :process_return!)
        end

        def create_customer_return
          Spree::CustomerReturn.transaction do
            @customer_return = Spree::CustomerReturn.find_or_initialize_by(number: number)
            update_attributes
          end
        end

        def update_attributes
          @customer_return.assign_attributes(attributes)
          @customer_return.save(validate: false)
        end

        def update_timestamps
          @customer_return.update_columns(timestamps)
        end

        def assign_return_items
          @return_items.each { |ri| ri.update_column(:customer_return_id, @customer_return.id) }
        end

        def set_callbacks
          Spree::CustomerReturn.set_callback(:create, :after, :process_return!)
        end

        def parser
          @parser ||= SpreeShopifyImporter::DataParsers::CustomerReturns::BaseData.new(@shopify_refund)
        end
      end
    end
  end
end
