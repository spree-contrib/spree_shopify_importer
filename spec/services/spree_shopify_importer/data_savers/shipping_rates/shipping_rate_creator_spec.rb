require 'spec_helper'

describe SpreeShopifyImporter::DataSavers::ShippingRates::ShippingRateCreator, type: :service do
  let(:shopify_order) { ShopifyAPI::Order.find(5_182_437_124) }
  let(:shopify_shipping_line) { shopify_order.shipping_lines.first }
  let!(:spree_shipment) { create(:shipment) }

  subject { described_class.new(shopify_shipping_line, shopify_order, spree_shipment) }

  before { authenticate_with_shopify }

  describe '#save!', vcr: { cassette_name: 'shopify/base_order' } do
    let(:shipping_rate) { Spree::ShippingRate.last }

    it 'creates shipping rate' do
      expect { subject.create! }.to change(Spree::ShippingRate, :count).by(1)
    end

    context 'sets a attributes' do
      before { subject.create! }

      it 'selected' do
        expect(shipping_rate).to be_selected
      end

      it 'cost' do
        expect(shipping_rate.cost).to eq 20.0.to_d
      end
    end

    context 'sets a associations' do
      let(:shipping_method) { Spree::ShippingMethod.last }
      before { subject.create! }

      it 'shipment' do
        expect(shipping_rate.shipment).to eq spree_shipment
      end

      it 'shipping method' do
        expect(shipping_rate.shipping_method).to eq shipping_method
      end
    end
  end
end
