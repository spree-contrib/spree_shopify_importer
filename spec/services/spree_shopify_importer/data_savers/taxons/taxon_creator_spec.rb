require 'spec_helper'

describe SpreeShopifyImporter::DataSavers::Taxons::TaxonCreator, type: :service do
  subject { described_class.new(shopify_data_feed) }

  before { ShopifyAPI::Base.site = 'https://api_key:passowrd@shop_domain.myshopify.com/admin' }

  describe '#create!', vcr: { cassette_name: 'shopify/base_custom_collection' } do
    let(:shopify_custom_collection) { ShopifyAPI::CustomCollection.find(388_567_107) }
    let(:shopify_data_feed) { create(:shopify_data_feed, data_feed: shopify_custom_collection.to_json) }
    let(:spree_taxon) { Spree::Taxon.where.not(parent: nil).last }

    it 'creates spree taxonomy' do
      expect { subject.create! }.to change(Spree::Taxonomy, :count).by(1)
    end

    it 'creates spree taxon' do
      expect { subject.create! }.to change { Spree::Taxon.where.not(parent: nil).reload.count }.by(1)
    end

    it 'assigns shopify data feed to spree taxon' do
      subject.create!

      expect(shopify_data_feed.reload.spree_object).to eq spree_taxon
    end

    context 'taxon attributes' do
      let(:permalink) { 'shopify-custom-collections/samplecollection' }

      before { subject.create! }

      it 'name' do
        expect(spree_taxon.name).to eq shopify_custom_collection.title
      end

      it 'permalink' do
        expect(spree_taxon.permalink).to eq permalink
      end

      it 'description' do
        expect(spree_taxon.description).to eq shopify_custom_collection.body_html
      end
    end

    context 'associations' do
      context 'products' do
        let!(:spree_product) { create(:product) }
        let!(:product_data_feed) do
          create(:shopify_data_feed,
                 shopify_object_type: 'ShopifyAPI::Product',
                 shopify_object_id: '9884552707',
                 spree_object: spree_product)
        end

        before { subject.create! }

        it 'assigns products to spree_taxon' do
          expect(spree_taxon.products).to contain_exactly(spree_product)
        end
      end
    end
  end
end
