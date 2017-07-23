require 'spec_helper'

describe ShopifyImport::DataParsers::ShippingRates::BaseData, type: :service do
  subject { described_class.new(shopify_shipping_line, shopify_order) }

  describe '#shipping_rate_attributes' do
    let(:shopify_shipping_line) { create(:shopify_shipping_line) }
    let(:shopify_order) { create(:shopify_order) }
    let(:shipping_method) { Spree::ShippingMethod.last }
    let(:result) do
      {
        selected: true,
        shipping_method: shipping_method,
        cost: shopify_shipping_line.price
      }
    end

    it 'returns hash of shipping rates attributes' do
      expect(subject.shipping_rate_attributes).to eq result
    end

    it 'creates a shipping method' do
      expect { subject.shipping_rate_attributes }.to change(Spree::ShippingMethod, :count).by(1)
    end

    it 'creates a calculator' do
      expect { subject.shipping_rate_attributes }.to change(Spree::Calculator, :count).by(1)
    end

    context 'when shipping line has missing price' do
      let(:shopify_shipping_line) { create(:shopify_shipping_line, price: nil) }
      let(:cost) do
        shopify_order.total_price.to_d - shopify_order.subtotal_price.to_d - shopify_order.total_tax.to_d
      end

      it 'calculates price' do
        expect(subject.shipping_rate_attributes[:cost]).to eq cost
      end
    end
  end
end
