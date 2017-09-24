module ShopifyImport
  module DataSavers
    module Users
      class UserBase < BaseDataSaver
        delegate :attributes, :temp_password, to: :parser

        private

        def assign_spree_user_to_data_feed
          @shopify_data_feed.update!(spree_object: @spree_user)
        end

        def generate_api_key
          @spree_user.try(:generate_spree_api_key!)
        end

        def parser
          @parser ||= ShopifyImport::DataParsers::Users::BaseData.new(shopify_customer)
        end

        def shopify_customer
          @shopify_customer ||= ShopifyAPI::Customer.new(data_feed)
        end

        def create_spree_addresses
          return if (addresses = shopify_customer.try(:addresses)).blank?

          addresses.each do |address|
            ShopifyImport::Importers::AddressImporterJob.perform_later(address.to_json, @spree_user)
          end
        end
      end
    end
  end
end
