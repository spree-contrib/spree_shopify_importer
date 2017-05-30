module Shopify
  class DataFeed < ApplicationRecord
    belongs_to :spree_object, polymorphic: true

    validates :shopify_object_id, :shopify_object_type, presence: true
    validates :shopify_object_id, uniqueness: { scope: :shopify_object_type }
    validates :spree_object_id, uniqueness: { scope: :spree_object_type }, allow_nil: true
  end
end
