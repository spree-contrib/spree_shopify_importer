module SpreeShopifyImporter
  module DataSavers
    module Products
      class ProductBase < BaseDataSaver
        delegate :attributes, :tags, :options, to: :parser

        private

        def assign_spree_product_to_data_feed
          @shopify_data_feed.update!(spree_object: @spree_product)
        end

        def add_tags
          @spree_product.tag_list = tags
          @spree_product.save!
        end

        def add_option_types
          return if options.blank?

          @spree_product.update!(option_type_ids: create_option_types)
        end

        def create_option_types
          options.map do |option|
            option_type = SpreeShopifyImporter::DataSavers::OptionTypes::OptionTypeCreator.new(option).create!
            option_type.id
          end
        end

        def create_spree_variants
          @shopify_product.variants.each do |variant|
            SpreeShopifyImporter::Importers::VariantImporterJob.perform_later(variant.to_json,
                                                                              @shopify_data_feed,
                                                                              @spree_product,
                                                                              variant_image(variant))
          end
        end

        # According to shopify api documentation variant can have only one image
        # https://help.shopify.com/api/reference/product_variant
        def variant_image(variant)
          variant_image = shopify_images.detect { |image| image.variant_ids.include?(variant.id) }
          return if variant_image.blank?

          variant_image.to_json
        end

        def create_spree_images
          shopify_images.select { |image| image.variant_ids.empty? }.each do |image|
            SpreeShopifyImporter::Importers::ImageImporterJob.perform_later(image.to_json,
                                                                            @shopify_data_feed,
                                                                            @spree_product)
          end
        end

        def shopify_images
          @shopify_images ||= shopify_product.images
        end

        def parser
          @parser ||= SpreeShopifyImporter::DataParsers::Products::BaseData.new(shopify_product)
        end

        def shopify_product
          @shopify_product ||= ShopifyAPI::Product.new(data_feed)
        end
      end
    end
  end
end
