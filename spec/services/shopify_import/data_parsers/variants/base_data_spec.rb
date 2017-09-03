require 'spec_helper'

RSpec.describe ShopifyImport::DataParsers::Variants::BaseData, type: :service do
  let(:spree_product) { create(:product) }
  let(:shopify_variant) { create(:shopify_variant) }
  subject { described_class.new(shopify_variant, spree_product) }

  context '#attributes' do
    let(:result) do
      {
        sku: shopify_variant.sku,
        price: shopify_variant.price,
        weight: shopify_variant.grams,
        position: shopify_variant.position,
        product_id: spree_product.id
      }
    end

    it 'creates a hash of variant attributes' do
      expect(subject.attributes).to eq result
    end
  end

  context '#option_value_ids' do
    let(:option_type) { create(:option_type) }
    let!(:f_option_value) do
      create(:option_value, name: shopify_variant.option1.strip.downcase, option_type: option_type)
    end
    let!(:s_option_value) do
      create(:option_value, name: shopify_variant.option2.strip.downcase, option_type: option_type)
    end
    let(:result) { [f_option_value.id, s_option_value.id, t_option_value.id] }

    context 'with valid product associations' do
      let!(:t_option_value) do
        create(:option_value, name: shopify_variant.option3.strip.downcase, option_type: option_type)
      end

      before { spree_product.option_types << option_type }

      it 'returns option value ids' do
        expect(subject.option_value_ids).to match_array(result)
      end
    end

    context "when product has't got option types" do
      let!(:t_option_value) do
        create(:option_value, name: shopify_variant.option3.strip.downcase, option_type: option_type)
      end

      it 'raises record not found' do
        expect do
          subject.option_value_ids
        end.to raise_error(ActiveRecord::RecordNotFound).with_message("Couldn't find Spree::OptionValue")
      end
    end

    context 'when one of option values does not exists' do
      before { spree_product.option_types << option_type }

      it 'raises record not found' do
        expect do
          subject.option_value_ids
        end.to raise_error(ActiveRecord::RecordNotFound).with_message("Couldn't find Spree::OptionValue")
      end
    end
  end

  context '#track_inventory?' do
    context 'shopify variant has inventory_management == shopify' do
      let(:shopify_variant) { create(:shopify_variant, inventory_management: 'shopify') }

      it 'returns true' do
        expect(subject).to be_track_inventory
      end
    end

    context 'shopify variant has inventory_management other than shopify' do
      let(:shopify_variant) { create(:shopify_variant, inventory_management: 'global') }

      it 'returns true' do
        expect(subject).not_to be_track_inventory
      end
    end
  end

  context '#backorderable?' do
    context 'shopify variant has inventory_policy == continue' do
      let(:shopify_variant) { create(:shopify_variant, inventory_policy: 'continue') }

      it 'returns true' do
        expect(subject).to be_backorderable
      end
    end

    context 'shopify variant has inventory_policy other than continue' do
      let(:shopify_variant) { create(:shopify_variant, inventory_policy: 'other') }

      it 'returns true' do
        expect(subject).not_to be_backorderable
      end
    end
  end

  context '#inventory_quantity' do
    it 'returns current inventory quantity' do
      expect(subject.inventory_quantity).to eq 0
    end
  end

  context '#stock_location' do
    let!(:spree_product) { create(:product) }

    it 'creates stock location' do
      expect { subject.stock_location }.to change(Spree::StockLocation, :count).by(1)
    end
    [
      { attribute: 'name', value: I18n.t(:shopify) },
      { attribute: 'default', value: false },
      { attribute: 'active', value: false }
    ].each do |stock_location_data|
      it "creates stock stock location with proper #{stock_location_data[:attribute]}" do
        expect(subject.stock_location.send(stock_location_data[:attribute])).to eq stock_location_data[:value]
      end
    end
  end
end
