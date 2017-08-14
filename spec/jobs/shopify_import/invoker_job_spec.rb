require 'spec_helper'

describe ShopifyImport::InvokerJob, type: :job do
  subject { described_class }

  describe '#perform_later' do
    it 'calls invoker service', :perform_enqueued do
      expect(ShopifyImport::Invoker).to receive(:new).and_call_original
      expect_any_instance_of(ShopifyImport::Invoker).to receive(:import!)

      described_class.perform_later
    end
  end
end
