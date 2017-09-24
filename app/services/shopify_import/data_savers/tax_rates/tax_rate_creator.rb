module ShopifyImport
  module DataSavers
    module TaxRates
      class TaxRateCreator < BaseDataSaver
        delegate :attributes, to: :parser

        def initialize(shopify_tax_line, shopify_address)
          @shopify_tax_line = shopify_tax_line
          @shopify_address = shopify_address
        end

        def create!
          Spree::TaxRate.transaction do
            Spree::TaxRate.create_with(calculator: calculator).find_or_create_by!(attributes)
          end
        end

        private

        def calculator
          @calculator ||= Spree::Calculator::ShopifyTax.create!
        end

        def parser
          @parser ||= ShopifyImport::DataParsers::TaxRates::BaseData.new(@shopify_tax_line, @shopify_address)
        end
      end
    end
  end
end
