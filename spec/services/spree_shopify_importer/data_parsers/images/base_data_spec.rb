require 'spec_helper'

describe SpreeShopifyImporter::DataParsers::Images::BaseData, type: :service do
  let(:shopify_image) { create(:shopify_image, src: 'https://spreecommerce.org/img/spree-logo.png') }
  subject { described_class.new(shopify_image) }

  describe '#attribtues' do
    let(:result) do
      {
        position: shopify_image.position,
        alt: 'spree-logo.png'
      }
    end

    it 'return hash of image attributes' do
      expect(subject.attributes).to eq result
    end
  end

  describe '#attachment', vcr: { cassette_name: 'spree-log.png' } do
    it 'return hash of image attributes' do
      expect(subject.attachment).to be_kind_of Tempfile
    end
  end

  describe '#timestamps' do
    let(:result) do
      {
        created_at: shopify_image.created_at.to_datetime,
        updated_at: shopify_image.updated_at.to_datetime
      }
    end

    it 'return hash of image timestamps' do
      expect(subject.timestamps).to eq result
    end
  end

  describe '#name' do
    let(:result) { 'spree-logo.png' }

    it 'return image name' do
      expect(subject.name).to eq result
    end
  end
end
