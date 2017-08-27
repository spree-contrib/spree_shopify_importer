module ShopifyImport
  module DataParsers
    module TaxRates
      class BaseData
        def initialize(shopify_tax_line, shopify_address)
          @shopify_tax_line = shopify_tax_line
          @shopify_address = shopify_address
        end

        def attributes
          @attributes ||= {
            name: @shopify_tax_line.title,
            amount: @shopify_tax_line.rate,
            zone: zone,
            tax_category: tax_category
          }
        end

        private

        # TODO: missing country code
        def zone
          Spree::Zone.find_each do |zone|
            return zone if zone.members.detect { |member| member.zoneable.try(:iso).eql?(country_code) }
          end
        end

        def country_code
          @country_code ||= @shopify_address.country_code
        end

        def tax_category
          Spree::TaxCategory.where(name: I18n.t(:shopify)).first_or_create!
        end
      end
    end
  end
end
