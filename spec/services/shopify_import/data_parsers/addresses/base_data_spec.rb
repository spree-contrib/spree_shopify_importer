require 'spec_helper'

describe ShopifyImport::DataParsers::Addresses::BaseData, type: :service do
  let(:spree_user) { create(:user) }
  let(:shopify_address) { create(:shopify_address) }

  subject { described_class.new(shopify_address) }

  describe '#address_attributes' do
    let(:state) { Spree::State.find_by!(abbr: shopify_address.province_code) }
    let(:country) { Spree::Country.find_by!(iso: shopify_address.country_code) }
    let(:result) do
      {
        firstname: shopify_address.first_name,
        lastname: shopify_address.last_name,
        address1: shopify_address.address1,
        address2: shopify_address.address2,
        company: shopify_address.company,
        phone: shopify_address.phone,
        city: shopify_address.city,
        zipcode: shopify_address.zip,
        state: state,
        country: country
      }
    end

    it 'returns hash of address attributes' do
      expect(subject.attributes).to eq result
    end

    context 'when there is no country' do
      let(:shopify_address) { create(:shopify_address, country_code: 'NONEXISTING') }

      it 'creates a country' do
        expect { subject.attributes }.to change(Spree::Country, :count).by(1)
      end
    end

    context 'when there is no state' do
      let(:shopify_address) { create(:shopify_address, province_code: 'NONEXISTING') }

      it 'creates a country' do
        expect { subject.attributes }.to change(Spree::State, :count).by(1)
      end
    end
  end
end
