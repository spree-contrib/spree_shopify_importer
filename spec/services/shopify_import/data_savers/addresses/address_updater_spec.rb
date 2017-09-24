require 'spec_helper'

describe ShopifyImport::DataSavers::Addresses::AddressUpdater, type: :service do
  let(:shopify_data_feed) do
    create(:shopify_data_feed,
           shopify_object_id: shopify_address.id,
           shopify_object_type: 'ShopifyAPI::Address',
           data_feed: shopify_address.to_json)
  end

  subject { described_class.new(shopify_data_feed, spree_address) }

  before { authenticate_with_shopify }

  describe '#update!' do
    let(:shopify_address) { create(:shopify_address) }
    let(:address_data_feed) { create(:shopify_data_feed, data_feed: shopify_address.to_json) }
    let!(:spree_address) { create(:address) }

    it 'does not create spree address' do
      expect { subject.update! }.not_to change(Spree::Address, :count)
    end

    context 'sets address attributes' do
      before { subject.update! }

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

      it 'assigns country to address' do
        subject.update!

        expect(spree_address.country).to eq country
      end

      it 'assigns state to address' do
        subject.update!

        expect(spree_address.state).to eq state
      end
    end
  end
end
