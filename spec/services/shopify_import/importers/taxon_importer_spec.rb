require 'spec_helper'

describe ShopifyImport::Importers::TaxonImporter, type: :service do
  subject { described_class.new(resource) }

  before { authenticate_with_shopify }

  describe '#import!', vcr: { cassette_name: 'shopify_import/importers/taxon_importer/import' } do
    let(:shopify_custom_collection) { ShopifyAPI::CustomCollection.find(:first) }
    let(:resource) { shopify_custom_collection.to_json }

    it 'creates shopify data feeds' do
      expect { subject.import! }.to change(Shopify::DataFeed, :count).by(1)
    end

    it 'creates spree taxonomy' do
      expect { subject.import! }.to change(Spree::Taxonomy, :count).by(1)
    end

    it 'creates spree taxons' do
      # One of taxons is taxonomy root.
      expect { subject.import! }.to change(Spree::Taxon, :count).by(2)
    end

    context 'with existing data feed' do
      let!(:shopify_data_feed) do
        create(:shopify_data_feed,
               shopify_object_id: shopify_custom_collection.id,
               shopify_object_type: 'ShopifyAPI::CustomCollection',
               data_feed: resource, spree_object: nil)
      end

      it 'does not create shopify data feeds' do
        expect { subject.import! }.not_to change(Shopify::DataFeed, :count)
      end

      it 'creates spree taxonomy' do
        expect { subject.import! }.to change(Spree::Taxonomy, :count).by(1)
      end

      it 'creates spree taxons' do
        # One of taxons is taxonomy root.
        expect { subject.import! }.to change(Spree::Taxon, :count).by(2)
      end

      context 'and taxon' do
        let!(:shopify_data_feed) do
          create(:shopify_data_feed,
                 shopify_object_id: shopify_custom_collection.id,
                 shopify_object_type: 'ShopifyAPI::CustomCollection',
                 data_feed: resource, spree_object: spree_taxon)
        end
        let(:spree_taxon) { create(:taxon, taxonomy: spree_taxonomy, parent: spree_taxonomy.root) }
        let(:spree_taxonomy) { create(:taxonomy, name: I18n.t('shopify_custom_collections')) }

        it 'does not create shopify data feeds' do
          expect { subject.import! }.not_to change(Shopify::DataFeed, :count)
        end

        it 'does not create spree taxonomy' do
          expect { subject.import! }.not_to change(Spree::Taxonomy, :count)
        end

        it 'does not create spree taxon' do
          # One of taxons is taxonomy root.
          expect { subject.import! }.not_to change(Spree::Taxon, :count)
        end
      end
    end
  end
end
