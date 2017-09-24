require 'spec_helper'

describe ShopifyImport::Delegator, type: :service do
  subject { described_class.new(target) }
  let!(:target) { spy('Object') }
  let(:helper) { ShopifyImport::RescueApiLimit }

  describe '#method_missing' do
    context 'respond to missing' do
      %w[save save! create create! update update!].each do |method_name|
        it "sends method #{method_name} to target" do
          subject.send(method_name, 'args')
          expect(target).to have_received(method_name).with('args')
        end
      end
    end

    context 'does not respond to missing' do
      it 'raises method missing error and does not send method to target' do
        expect { subject.send(:random_method) }.to raise_error NoMethodError
        expect(target).not_to have_received(:random_method)
      end
    end
  end
end
