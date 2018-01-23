module SpreeShopifyImporter
  module DataSavers
    module Images
      class ImageBase < BaseDataSaver
        delegate :attributes, :timestamps, :name, :valid_path?, to: :parser

        private

        def assign_spree_image_to_data_feed
          @shopify_data_feed.update!(spree_object: @spree_image)
        end

        def update_timestamps
          @spree_image.update_columns(timestamps)
        end

        def parser
          @parser ||= SpreeShopifyImporter::DataParsers::Images::BaseData.new(shopify_image)
        end

        def shopify_image
          @shopify_image ||= ShopifyAPI::Image.new(data_feed)
        end
      end
    end
  end
end
