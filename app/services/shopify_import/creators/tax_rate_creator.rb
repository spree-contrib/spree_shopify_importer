module ShopifyImport
  module Creators
    class TaxRateCreator
      def initialize(shopify_tax_line, shopify_address)
        @shopify_tax_line = shopify_tax_line
        @shopify_address = shopify_address
      end

      def create!
        Spree::TaxRate.transaction do
          Spree::TaxRate.create_with(calculator: calculator).find_or_create_by!(tax_rate_attributes)
        end
      end

      private

      def tax_rate_attributes
        @tax_rate_attributes ||= parser.tax_rate_attributes
      end

      def calculator
        @calculator ||= Spree::Calculator::ShopifyTax.create!
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::TaxRates::BaseData.new(@shopify_tax_line, @shopify_address)
      end
    end
  end
end
