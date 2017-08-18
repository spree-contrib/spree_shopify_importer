module ShopifyImport
  module Creators
    class ImageCreator < BaseCreator
      delegate :attributes, :timestamps, :name, :valid_path?, to: :parser

      def initialize(shopify_data_feed, spree_object)
        super(shopify_data_feed)
        @spree_object = spree_object # can be product or variant
      end

      def save!
        Spree::Image.transaction do
          return unless valid_path?
          return if @spree_object.images.pluck(:attachment_file_name).include?(name)

          create_spree_image
          assign_spree_image_to_data_feed
        end
        update_timestamps
      end

      private

      def create_spree_image
        @spree_image = @spree_object.images.create!(attributes)
      end

      def assign_spree_image_to_data_feed
        @shopify_data_feed.update!(spree_object: @spree_image)
      end

      def update_timestamps
        @spree_image.update_columns(timestamps)
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::Images::BaseData.new(shopify_image)
      end

      def shopify_image
        @shopify_image ||= ShopifyAPI::Image.new(data_feed)
      end
    end
  end
end
