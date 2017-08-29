require 'spec_helper'

RSpec.describe ShopifyImport::Creators::AddressCreator do
  let(:shopify_data_feed) do
    create(:shopify_data_feed,
           shopify_object_id: shopify_address.id,
           shopify_object_type: 'ShopifyAPI::Address',
           data_feed: shopify_address.to_json)
  end
  subject { described_class.new(shopify_data_feed, spree_user) }

  before { authenticate_with_shopify }

  describe '#save!' do
    let(:shopify_address) { create(:shopify_address) }
    let(:address_data_feed) { create(:shopify_data_feed, data_feed: shopify_address.to_json) }
    let(:spree_user) { create(:user) }

    it 'creates spree address' do
      expect { subject.create! }.to change(Spree::Address, :count).by(1)
    end

    context 'sets address attributes' do
      let(:spree_address) { Spree::Address.last }

      before { subject.create! }

      it 'firstname' do
        expect(spree_address.firstname).to eq shopify_address.first_name
      end

      it 'lastname' do
        expect(spree_address.lastname).to eq shopify_address.last_name
      end

      it 'address1' do
        expect(spree_address.address1).to eq shopify_address.address1
      end

      it 'address2' do
        expect(spree_address.address2).to eq shopify_address.address2
      end

      it 'company' do
        expect(spree_address.company).to eq shopify_address.company
      end

      it 'city' do
        expect(spree_address.city).to eq shopify_address.city
      end

      it 'phone' do
        expect(spree_address.phone).to eq shopify_address.phone
      end

      it 'zipcode' do
        expect(spree_address.zipcode).to eq shopify_address.zip
      end
    end

    context 'associations' do
      let(:country) { Spree::Country.find_by!(iso: shopify_address.country_code) }
      let(:state) { Spree::State.find_by(abbr: shopify_address.province_code) }
      let(:address) { Spree::Address.last }

      it 'assigns new address to user' do
        expect { subject.create! }.to change { spree_user.addresses.reload.count }.by(1)
      end

      it 'assigns country to address' do
        subject.create!

        expect(address.country).to eq country
      end

      it 'assigns state to address' do
        subject.create!

        expect(address.state).to eq state
      end

      it 'assigns spree address to shopify data feed' do
        subject.create!

        expect(shopify_data_feed.reload.spree_object).to eq address
      end
    end
  end
end
