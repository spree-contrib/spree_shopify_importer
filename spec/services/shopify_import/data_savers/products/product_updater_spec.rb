require 'spec_helper'

describe ShopifyImport::DataSavers::Products::ProductUpdater, type: :service do
  include ActiveJob::TestHelper

  subject { described_class.new(product_data_feed, spree_product) }

  before { authenticate_with_shopify }

  describe '#update!' do
    context 'with base product data feed', vcr: { cassette_name: 'shopify/base_product' } do
      let!(:spree_product) { create(:product) }
      let(:shopify_product) { ShopifyAPI::Product.find(11_101_525_828) }
      let(:product_data_feed) do
        create(:shopify_data_feed,
               shopify_object_id: shopify_product.id, data_feed: shopify_product.to_json)
      end

      it 'does not create spree product' do
        expect { subject.update! }.not_to change(Spree::Product, :count)
      end

      context 'product attributes' do
        let(:shipping_category) { Spree::ShippingCategory.find_by!(name: I18n.t(:shopify)) }

        before { subject.update! }

        it 'description' do
          expect(spree_product.description).to eq shopify_product.body_html
        end

        it 'available_on' do
          expect(spree_product.available_on).to eq shopify_product.published_at
        end

        it 'slug' do
          expect(spree_product.slug).to eq shopify_product.handle
        end

        it 'created_at' do
          expect(spree_product.created_at).to eq shopify_product.created_at
        end

        it 'price' do
          expect(spree_product.price).to eq shopify_product.variants.first.price.to_d
        end

        it 'shipping_category' do
          expect(spree_product.shipping_category).to eq shipping_category
        end
      end

      context 'product tags' do
        it 'creates product tags' do
          subject.update!

          expect(spree_product.reload.tag_list).to match_array %w[tag some product]
        end
      end

      context 'spree variants' do
        it 'enqueue a variant importer job' do
          expect { subject.update! }.to enqueue_job(ShopifyImport::Importers::VariantImporterJob).once
        end

        it 'creates spree variant' do
          expect do
            perform_enqueued_jobs do
              subject.update!
            end
          end.to change(Spree::Variant, :count).by(1)
        end

        it 'assings variants to product' do
          perform_enqueued_jobs do
            subject.update!
          end

          expect(Spree::Variant.last.product).to eq spree_product
        end

        it 'creates data feeds' do
          expect do
            perform_enqueued_jobs do
              subject.update!
            end
          end.to change { Shopify::DataFeed.where(shopify_object_type: 'ShopifyAPI::Variant').reload.count }.by(1)
        end

        context 'with variant image', vcr: { cassette_name: 'shopify/product_with_variant_image' } do
          it 'creates spree image' do
            expect do
              perform_enqueued_jobs do
                subject.update!
              end
            end.to change { Spree::Image.count }.by(2)
          end
        end
      end

      context 'spree images' do
        it 'enqueue a variant importer job' do
          expect { subject.update! }.to enqueue_job(ShopifyImport::Importers::ImageImporterJob).once
        end

        it 'creates spree variant' do
          expect do
            perform_enqueued_jobs do
              subject.update!
            end
          end.to change(Spree::Image, :count).by(1)
        end

        it 'assings variants to product' do
          perform_enqueued_jobs do
            subject.update!
          end

          expect(Spree::Image.last.viewable).to eq spree_product.master
        end

        it 'creates data feeds' do
          expect do
            perform_enqueued_jobs do
              subject.update!
            end
          end.to change { Shopify::DataFeed.where(shopify_object_type: 'ShopifyAPI::Image').reload.count }.by(1)
        end
      end

      context 'option types' do
        let(:shopify_product) do
          create(:shopify_product_multiple_variants, variants_count: 2, options_count: 2, handle: 'some-handle')
        end
        let(:option_types_names) { shopify_product.options.map(&:name).map(&:downcase) }

        it 'creates variants' do
          expect do
            perform_enqueued_jobs do
              subject.update!
            end
          end.to change(Spree::Variant, :count).by(2)
        end

        it 'creates option types' do
          expect { subject.update! }.to change(Spree::OptionType, :count).by(2)
        end

        it 'assigns option types to product' do
          subject.update!
          expect(spree_product.option_types.pluck(:name)).to match_array option_types_names
        end

        context 'option values' do
          let(:option_type1) { Spree::OptionType.find_by(name: shopify_product.options.first.name.downcase) }
          let(:option_type2) { Spree::OptionType.find_by(name: shopify_product.options.first.name.downcase) }
          let(:option_type1_values) { shopify_product.options.first.values.map(&:downcase) }
          let(:option_type2_values) { shopify_product.options.last.values.map(&:downcase) }

          it 'creates option values' do
            expect { subject.update! }.to change(Spree::OptionValue, :count).by(6)
          end

          it 'assigns option values to option types' do
            subject.update!
            expect(option_type1.option_values.pluck(:name)).to match_array option_type1_values
            expect(option_type2.option_values.pluck(:name)).to match_array option_type2_values
          end
        end
      end
    end
  end
end
