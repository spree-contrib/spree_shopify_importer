require 'spec_helper'

describe ShopifyImport::Importers::PaymentImporter, type: :service do
  let!(:transaction) { create(:shopify_transaction) }
  let!(:parent_feed) { create(:shopify_data_feed) }
  let!(:spree_order) { create(:order) }

  subject { described_class.new(transaction, parent_feed, spree_order) }

  describe '#import!' do
    it 'creates shopify data feeds' do
      expect { subject.import! }.to change(Shopify::DataFeed, :count).by(1)
    end

    it 'creates spree payment' do
      expect { subject.import! }.to change(Spree::Payment, :count).by(1)
    end
  end
end
