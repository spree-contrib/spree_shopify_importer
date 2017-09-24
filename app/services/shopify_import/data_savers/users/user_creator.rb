module ShopifyImport
  module DataSavers
    module Users
      class UserCreator < UserBase
        def create!
          Spree.user_class.transaction do
            @spree_user = create_spree_user
            generate_api_key
            assign_spree_user_to_data_feed
            create_spree_addresses
          end
        end

        private

        def create_spree_user
          user = Spree.user_class.new(merged_attributes)
          user.try(:skip_confirmation!)
          user.save!
          user
        end

        def merged_attributes
          attributes
            .select { |a| Spree.user_class.attribute_method?(a) }
            .merge(password: temp_password, password_confirmation: temp_password)
        end
      end
    end
  end
end
