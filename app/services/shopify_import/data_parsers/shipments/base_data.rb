module ShopifyImport
  module DataParsers
    module Shipments
      class BaseData
        def initialize(shopify_fulfillment)
          @shopify_fulfillment = shopify_fulfillment
        end

        def number
          @number ||= "SH#{@shopify_fulfillment.id}"
        end

        def attributes
          @attributes ||= {
            stock_location: stock_location,
            tracking: @shopify_fulfillment.tracking_number,
            state: shipment_state
          }
        end

        def timestamps
          @timestamps ||= {
            created_at: @shopify_fulfillment.created_at.to_datetime,
            updated_at: @shopify_fulfillment.updated_at.to_datetime,
            shipped_at: shipped_at
          }
        end

        private

        def stock_location
          Spree::StockLocation
            .create_with(default: false, active: false)
            .find_or_create_by(name: I18n.t(:shopify))
        end

        def shipment_state
          @shipment_state ||= case @shopify_fulfillment.status
                              when 'pending' then :pending
                              when 'success' then :shipped
                              when 'cancelled', 'error', 'failure' then :canceled
                              else
                                raise NotImplementedError
                              end
        end

        def shipped_at
          @shopify_fulfillment.created_at.to_datetime if shipment_state.eql?(:shipped)
        end
      end
    end
  end
end
