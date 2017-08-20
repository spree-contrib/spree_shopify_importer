require 'spec_helper'

describe ShopifyImport::Importers::AddressImporter, type: :service do
  subject { described_class.new(resource, spree_user) }

  before { authenticate_with_shopify }

  describe '#import!' do
    let(:resource) { create(:shopify_address).to_json }
    let(:spree_user) { create(:user) }

    it 'creates shopify data feeds' do
      expect { subject.import! }.to change(Shopify::DataFeed, :count).by(1)
    end

    it 'creates spree address' do
      expect { subject.import! }.to change(Spree::Address, :count).by(1)
    end
  end
end
