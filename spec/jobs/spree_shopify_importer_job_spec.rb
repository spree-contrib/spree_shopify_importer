require 'spec_helper'

describe SpreeShopifyImporterJob, type: :job do
  describe '.queue_as' do
    it 'uses default spree config queue' do
      expect(described_class.new.queue_name).to eq 'default'
    end

    context 'with custom value' do
      before do
        Spree::Config[:shopify_import_queue] = 'shopify_import'
      end

      it 'uses custom spree config queue' do
        expect(described_class.new.queue_name).to eq 'shopify_import'
      end
    end
  end
end
