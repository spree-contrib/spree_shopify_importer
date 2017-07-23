module Spree
  class Calculator
    module Shipping
      class Shopify < ShippingCalculator
        preference :amount, :decimal, default: 0
        preference :currency, :string, default: -> { Spree::Config[:currency] }

        def self.description
          I18n.t(:shopify)
        end

        def compute_package(package)
          package.order.shipment_total
        end
      end
    end
  end
end
