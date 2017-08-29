module ShopifyImport
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
          @country ||= Spree::Country.find_or_create_by!(iso: @shopify_address.country_code) do |country|
            country.name = @shopify_address.try(:country_name) || @shopify_address.try(:country)
            country.iso_name = country.name.upcase
          end
        end

        # TODO: find state
        def state
          return if (abbr = @shopify_address.province_code).blank?

          @state ||= country.states.find_or_create_by!(abbr: abbr) do |state|
            state.name = @shopify_address.province
          end
        end
      end
    end
  end
end
