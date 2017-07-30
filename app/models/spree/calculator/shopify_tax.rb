module Spree
  class Calculator
    class ShopifyTax < DefaultTax
      def self.description
        I18n.t(:shopify)
      end
    end
  end
end
