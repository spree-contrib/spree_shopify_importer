require 'spec_helper'

describe SpreeShopifyImporter::DataSavers::Images::ImageUpdater, type: :service do
  subject { described_class.new(shopify_data_feed, spree_image, spree_object) }
  let(:spree_image) { create(:image) }
  let(:shopify_data_feed) do
    create(:shopify_data_feed,
           shopify_object_type: 'ShopifyAPI::Image',
           shopify_object_id: shopify_image.id,
           data_feed: shopify_image.to_json)
  end

  describe '#save!', vcr: { cassette_name: 'shopify_import/creators/image_creator' } do
    let(:shopify_image) do
      create(:shopify_image,
             src: 'https://cdn.shopify.com/s/files/1/2051/3691/'\
                   'products/Screenshot_2017-03-03_14.45.16_29b97e8b-f008-460f-8733-b33d551d7140.png?v=1496631699')
    end

    context 'with spree product' do
      let!(:spree_object) { create(:product) }

      it_behaves_like 'updates spree image'
    end

    context 'with spree variant' do
      let!(:spree_object) { create(:variant) }

      it_behaves_like 'updates spree image'
    end
  end
end
