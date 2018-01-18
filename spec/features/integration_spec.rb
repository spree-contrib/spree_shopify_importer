require 'spec_helper'

RSpec.feature 'end to end import' do
  include ActiveJob::TestHelper

  it 'imports successfully', vcr: { cassette_name: 'integration' } do
    perform_enqueued_jobs do
      SpreeShopifyImporter::Invoker.new(
        credentials: {
          api_key: '0a9445b7b067719a0af024610364ee34', password: '800f97d6ea1a768048851cdd99a9101a',
          shop_domain: 'spree-shopify-importer-test-store.myshopify.com'
        }
      ).import!
    end

    expect(Spree::Product.count).to eq 2
    expect(Spree::Variant.count).to eq 4
    expect(Spree::Image.count).to eq 3
    expect(Spree.user_class.count).to eq 3
    expect(Spree::Taxonomy.count).to eq 1
    expect(Spree::Taxon.count).to eq 3
    expect(Spree::Order.count).to eq 1
    expect(Spree::LineItem.count).to eq 2
    expect(Spree::Payment.count).to eq 1
    expect(Spree::Shipment.count).to eq 3
    expect(Spree::ShippingRate.count).to eq 3
    expect(Spree::InventoryUnit.count).to eq 8
    expect(Spree::Address.count).to eq 5
    expect(Spree::ReturnAuthorization.count).to eq 1
    expect(Spree::ReturnItem.count).to eq 1
    expect(Spree::CustomerReturn.count).to eq 1
    expect(Spree::Reimbursement.count).to eq 1
    expect(Spree::Refund.count).to eq 1
  end

  it 'multiple imports successfully', vcr: { cassette_name: 'multiple_integration' } do
    perform_enqueued_jobs do
      SpreeShopifyImporter::Invoker.new(
        credentials: {
          api_key: '0a9445b7b067719a0af024610364ee34', password: '800f97d6ea1a768048851cdd99a9101a',
          shop_domain: 'spree-shopify-importer-test-store.myshopify.com'
        }
      ).import!
      SpreeShopifyImporter::Invoker.new(
        credentials: {
          api_key: '0a9445b7b067719a0af024610364ee34', password: '800f97d6ea1a768048851cdd99a9101a',
          shop_domain: 'spree-shopify-importer-test-store.myshopify.com'
        }
      ).import!
    end

    expect(Spree::Product.count).to eq 2
    expect(Spree::Variant.count).to eq 4
    expect(Spree::Image.count).to eq 3
    expect(Spree.user_class.count).to eq 3
    expect(Spree::Taxonomy.count).to eq 1
    expect(Spree::Taxon.count).to eq 3
    expect(Spree::Order.count).to eq 1
    expect(Spree::LineItem.count).to eq 2
    expect(Spree::Payment.count).to eq 1
    expect(Spree::Shipment.count).to eq 3
    expect(Spree::ShippingRate.count).to eq 3
    expect(Spree::InventoryUnit.count).to eq 8
    expect(Spree::Address.count).to eq 5
    expect(Spree::ReturnAuthorization.count).to eq 1
    expect(Spree::ReturnItem.count).to eq 1
    expect(Spree::CustomerReturn.count).to eq 1
    expect(Spree::Reimbursement.count).to eq 1
    expect(Spree::Refund.count).to eq 1
  end
end
