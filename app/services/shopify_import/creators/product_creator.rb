module ShopifyImport
  module Creators
    class ProductCreator < BaseCreator
      delegate :attributes, :tags, :option_types, to: :parser

      def save!
        Spree::Product.transaction do
          @spree_product = create_spree_product
          assign_spree_product_to_data_feed
          add_option_types
          add_tags
        end
        create_spree_variants
        create_spree_images
      end

      private

      def create_spree_product
        Spree::Product.create!(attributes)
      end

      def assign_spree_product_to_data_feed
        @shopify_data_feed.update!(spree_object: @spree_product)
      end

      def add_tags
        @spree_product.tag_list.add(tags, parse: true)
        @spree_product.save!
      end

      def add_option_types
        return if shopify_product.options.blank?

        @spree_product.update!(option_type_ids: create_option_types)
      end

      def create_option_types
        option_types.map do |option_type, option_values|
          spree_option_type =
            Spree::OptionType.where('lower(name) = ?', option_type).first_or_create!(name: option_type,
                                                                                     presentation: option_type)
          create_option_values(spree_option_type, option_values)
          spree_option_type.id
        end
      end

      def create_option_values(spree_option_type, option_values)
        option_values.each do |option_value|
          spree_option_type
            .option_values.where('lower(name) = ?', option_value)
            .first_or_create!(name: option_value, presentation: option_value)
        end
      end

      def create_spree_variants
        @shopify_product.variants.each do |variant|
          ShopifyImport::Importers::VariantImporterJob.perform_later(variant.to_json,
                                                                     @shopify_data_feed,
                                                                     @spree_product)
        end
      end

      def create_spree_images
        shopify_images.select { |image| image.variant_ids.empty? }.each do |image|
          ShopifyImport::Importers::ImageImporterJob.perform_later(image.to_json, @shopify_data_feed, @spree_product)
        end
      end

      def shopify_images
        @shopify_images ||= shopify_product.images
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::Products::BaseData.new(shopify_product)
      end

      def shopify_product
        @shopify_product ||= ShopifyAPI::Product.new(data_feed)
      end
    end
  end
end
