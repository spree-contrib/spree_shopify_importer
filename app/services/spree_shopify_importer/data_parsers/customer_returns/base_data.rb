module SpreeShopifyImporter
  module DataParsers
    module CustomerReturns
      class BaseData
        def initialize(shopify_refund)
          @shopify_refund = shopify_refund
        end

        def number
          @number ||= "SCR#{@shopify_refund.id}"
        end

        def attributes
          @attributes ||= {
            stock_location: stock_location
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
      end
    end
  end
end
