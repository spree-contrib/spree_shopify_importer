require 'spec_helper'

describe ShopifyImport::Importers::UserImporter, type: :service do
  subject { described_class.new(resource) }

  before { authenticate_with_shopify }

  describe '#import!', vcr: { cassette_name: 'shopify_import/importers/user_importer/import' } do
    let(:resource) { ShopifyAPI::Customer.find(5_667_226_244).to_json }

    it 'creates shopify data feeds' do
      expect { subject.import! }.to change(Shopify::DataFeed, :count).by(2)
    end

    it 'creates spree users' do
      expect { subject.import! }.to change(Spree.user_class, :count).by(1)
    end
  end
end
