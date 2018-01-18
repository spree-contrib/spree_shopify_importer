module SpreeShopifyImporter
  module DataParsers
    module Addresses
      class BaseData
        def initialize(shopify_address)
          @shopify_address = shopify_address
        end

        # rubocop:disable Metrics/MethodLength
        def attributes
          {
            firstname: @shopify_address.first_name,
            lastname: @shopify_address.last_name,
            address1: @shopify_address.address1,
            address2: @shopify_address.address2,
            company: @shopify_address.company,
            phone: @shopify_address.phone,
            city: @shopify_address.city,
            zipcode: @shopify_address.zip,
            state: state,
            country: country
          }
        end
        # rubocop:enable Metrics/MethodLength

        private

        def country
          @country ||= find_country || create_country
        end

        def find_country
          Spree::Country.find_by(iso: iso) || Spree::Country.find_by(name: country_name)
        end

        def create_country
          Spree::Country.create!(iso: iso,
                                 name: country_name,
                                 iso_name: country_name.upcase)
        end

        def iso
          @iso ||= @shopify_address.country_code
        end

        def country_name
          @country_name ||= @shopify_address.try(:country_name) || @shopify_address.try(:country)
        end

        def state
          return if (abbr = @shopify_address.province_code).blank?

          @state ||= find_state(abbr) || create_state(abbr)
        end

        def find_state(abbr)
          country.states.find_by(abbr: abbr) || country.states.find_by(name: @shopify_address.province)
        end

        def create_state(abbr)
          country.states.create!(abbr: abbr, name: @shopify_address.province)
        end
      end
    end
  end
end
