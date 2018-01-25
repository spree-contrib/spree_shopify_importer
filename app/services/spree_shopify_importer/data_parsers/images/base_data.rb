require 'curb'

module SpreeShopifyImporter
  module DataParsers
    module Images
      class BaseData
        def initialize(shopify_image)
          @shopify_image = shopify_image
        end

        def attributes
          @attributes ||= {
            position: @shopify_image.position,
            alt: name
          }
        end

        def attachment
          @attachment ||= open(@shopify_image.src)
        end

        def timestamps
          @timestamps ||= {
            created_at: @shopify_image.created_at.to_datetime,
            updated_at: @shopify_image.updated_at.to_datetime
          }
        end

        def name
          @name ||= URI.parse(uri).to_s.split('?v=').first.split('/')[-1].gsub(pattern, '_')
        end

        def valid_path?
          @shopify_image.src.present? && content_is_image?
        end

        private

        def content_is_image?
          Curl::Easy.http_head(URI.parse(uri).to_s).content_type.starts_with?('image')
        end

        def uri
          @uri ||= Addressable::URI.escape(@shopify_image.src)
        end

        def pattern
          %r([&$+,\/:;=?@<>\[\]\{\}\|\\\^~%# ])
        end
      end
    end
  end
end
