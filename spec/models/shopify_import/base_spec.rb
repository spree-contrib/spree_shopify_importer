require 'spec_helper'

RSpec.describe ShopifyImport::Base, type: :model do
  subject { described_class }

  describe '.count', vcr: { cassette_name: 'shopify_import/base/count' } do
    it 'raises error ActiveResource::ResourceNotFound' do
      authenticate_with_shopify

      expect { subject.count }.to raise_error ActiveResource::ResourceNotFound
    end
  end
end
