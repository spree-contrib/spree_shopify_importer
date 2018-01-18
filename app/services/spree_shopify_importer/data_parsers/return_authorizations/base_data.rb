module SpreeShopifyImporter
  module DataParsers
    module ReturnAuthorizations
      class BaseData
        def initialize(shopify_refund, spree_order)
          @shopify_refund = shopify_refund
          @spree_order = spree_order
        end

        def number
          @number ||= "SRE#{@shopify_refund.id}"
        end

        def attributes
          @attributes ||= {
            state: :authorized,
            order: @spree_order,
            memo: @shopify_refund.note,
            stock_location: stock_location,
            reason: reason
          }
        end

        def timestamps
          @timestamps ||= {
            created_at: @shopify_refund.created_at.to_datetime,
            updated_at: @shopify_refund.processed_at.try(:to_datetime)
          }
        end

        private

        def stock_location
          Spree::StockLocation.create_with(default: false, active: false).find_or_create_by(name: I18n.t(:shopify))
        end

        def reason
          Spree::ReturnAuthorizationReason.create_with(active: false).find_or_create_by(name: I18n.t(:shopify))
        end
      end
    end
  end
end
