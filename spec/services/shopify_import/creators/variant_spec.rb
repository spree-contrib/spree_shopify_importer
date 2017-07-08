require 'spec_helper'

RSpec.describe ShopifyImport::Creators::Variant, type: :service do
  let(:spree_product) { create(:product) }
  let(:shopify_variant) { create(:shopify_variant, sku: '1234') }
  let(:option_type) { create(:option_type) }
  let(:shopify_data_feed) do
    create(:shopify_data_feed,
           shopify_object_type: 'ShopifyAPI::Variant',
           shopify_object_id: shopify_variant.id,
           data_feed: shopify_variant.to_json)
  end
  let!(:f_option_value) do
    create(:option_value, name: shopify_variant.option1.strip.downcase, option_type: option_type)
  end
  let!(:s_option_value) do
    create(:option_value, name: shopify_variant.option2.strip.downcase, option_type: option_type)
  end
  let!(:t_option_value) do
    create(:option_value, name: shopify_variant.option3.strip.downcase, option_type: option_type)
  end

  subject { described_class.new(shopify_data_feed, spree_product) }

  before { spree_product.option_types << option_type }

  describe '#save!' do
    it 'creates spree variant' do
      expect { subject.save! }.to change(Spree::Variant, :count).by(1)
    end

    it 'assigns new variant to product' do
      expect { subject.save! }.to change { spree_product.variants.reload.count }.by(1)
    end

    it 'assigns option values to product' do
      subject.save!
      variant = Spree::Variant.last
      expect(variant.option_values).to contain_exactly(f_option_value, s_option_value, t_option_value)
    end

    context 'base variant attributes' do
      let(:spree_variant) { Spree::Variant.last }

      before { subject.save! }

      it 'saves variant sku' do
        expect(spree_variant.sku).to eq shopify_variant.sku
      end

      it 'saves variant price' do
        expect(spree_variant.price).to eq shopify_variant.price
      end

      it 'saves variant weight' do
        expect(spree_variant.weight).to eq shopify_variant.grams
      end
    end

    context 'variant stock' do
      context 'track inventory' do
        let(:spree_variant) { Spree::Variant.last }

        before { subject.save! }

        context 'resource in shopify was tracking inventory' do
          let(:shopify_variant) { create(:shopify_variant, inventory_management: 'shopify') }

          it 'then it is tracking inventory' do
            expect(spree_variant).to be_track_inventory
          end
        end

        context 'resource in shopify was not tracking inventory' do
          let(:shopify_variant) { create(:shopify_variant, inventory_management: 'not_shopify') }

          it 'then it is not tracking inventory' do
            expect(spree_variant).not_to be_track_inventory
          end
        end
      end

      context 'backorderable' do
        let(:stock_location) { Spree::StockLocation.find_by(name: I18n.t(:shopify)) }
        let(:spree_variant_stock_item) { Spree::Variant.last.stock_items.find_by(stock_location: stock_location) }

        before { subject.save! }

        context 'resource in shopify was backorderable' do
          let(:shopify_variant) { create(:shopify_variant, inventory_policy: 'continue') }

          it 'then it is backroderable' do
            expect(spree_variant_stock_item.reload).to be_backorderable
          end
        end

        context 'resource in shopify was not backorderable' do
          let(:shopify_variant) { create(:shopify_variant, inventory_policy: 'not_continue') }

          it 'then it is not backroderable' do
            expect(spree_variant_stock_item).not_to be_backorderable
          end
        end
      end

      context 'inventory quantity' do
        let(:stock_location) { Spree::StockLocation.find_by(name: I18n.t(:shopify)) }
        let(:spree_variant_stock_item) { Spree::Variant.last.stock_items.find_by(stock_location: stock_location) }

        before { subject.save! }

        context 'when variant is tracking inventory' do
          let(:shopify_variant) { create(:shopify_variant, inventory_management: 'shopify', inventory_quantity: 5) }

          it 'it sets variant inventory_quantity' do
            expect(spree_variant_stock_item.count_on_hand).to eq 5
          end
        end

        context 'when variant is not tracking inventory' do
          let(:shopify_variant) { create(:shopify_variant, inventory_management: 'not_shopify', inventory_quantity: 5) }

          it 'it sets variant inventory_quantity' do
            expect(spree_variant_stock_item.count_on_hand).to eq 0
          end
        end
      end
    end
  end
end
