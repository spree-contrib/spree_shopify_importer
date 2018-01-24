module SpreeShopifyImporter
  module DataSavers
    module ReturnAuthorizations
      class ReturnAuthorizationCreator < BaseDataSaver
        delegate :number, :attributes, :timestamps, to: :parser

        def initialize(shopify_data_feed, spree_order)
          super(shopify_data_feed)
          @spree_order = spree_order
        end

        def create
          Spree::ReturnAuthorization.transaction do
            @spree_return_authorization = @spree_order.return_authorizations.find_or_initialize_by(number: number)
            update_attributes
            assign_spree_order_to_data_feed
          end
          update_timestamps
          @spree_return_authorization
        end

        private

        def update_attributes
          @spree_return_authorization.assign_attributes(attributes)
          @spree_return_authorization.save(validate: false)
        end

        def assign_spree_order_to_data_feed
          @shopify_data_feed.update!(spree_object: @spree_return_authorization)
        end

        def update_timestamps
          @spree_return_authorization.update_columns(timestamps)
        end

        def parser
          @parser ||= SpreeShopifyImporter::DataParsers::ReturnAuthorizations::BaseData.new(shopify_refund,
                                                                                            @spree_order)
        end

        def shopify_refund
          @shopify_refund ||= ShopifyAPI::Refund.new(data_feed)
        end
      end
    end
  end
end
