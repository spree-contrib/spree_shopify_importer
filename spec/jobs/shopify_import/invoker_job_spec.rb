require 'spec_helper'

describe ShopifyImport::InvokerJob, type: :job do
  subject { described_class }

  describe '#perform' do
    it 'calls invoker service' do
      expect(ShopifyImport::Invoker).to receive(:new).and_call_original
      expect_any_instance_of(ShopifyImport::Invoker).to receive(:import!)

      described_class.new.perform
    end
  end
end
