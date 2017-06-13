require 'spec_helper'

RSpec.describe ShopifyImport::Creators::Address do
  subject { described_class.new(shopify_address, spree_user) }

  before { authenticate_with_shopify }

  describe '#save!' do
    let(:shopify_address) { create(:shopify_address) }
    let(:address_data_feed) { create(:shopify_data_feed, data_feed: shopify_address.to_json) }
    let(:spree_user) { create(:user) }

    it 'creates spree address' do
      expect { subject.save! }.to change(Spree::Address, :count).by(1)
    end

    context 'relationships' do
      it 'assigns new address to user' do
        expect { subject.save! }.to change { spree_user.addresses.reload.count }.by(1)
      end

      it 'assigns country to address' do
        subject.save!

        expect(address.country_id).to be_present
      end
    end

    xcontext 'address attributes' do
      let(:spree_address) { Spree::Address.last }

      it 'email' do
        subject.save!

        expect(spree_address.email).to eq(shopify_address.email)
      end

      it 'created_at' do
        subject.save!

        expect(spree_address.created_at).to be_within(1.second).of(shopify_address.created_at)
      end
    end
  end
end
