shared_examples_for 'create spree image' do
  it 'creates spree image' do
    expect { subject.save! }.to change(Spree::Image, :count).by(1)
  end

  context 'sets attributes' do
    before { subject.save! }

    it 'attachment' do
      expect(spree_image.attachment).to be_present
    end

    it 'position' do
      expect(spree_image.position).to eq shopify_image.position
    end

    it 'alt' do
      expect(spree_image.alt).to eq 'Screenshot_2017-03-03_14.45.16_29b97e8b-f008-460f-8733-b33d551d7140.png'
    end
  end

  context 'sets timestamps' do
    before { subject.save! }

    it 'created at' do
      expect(spree_image.created_at.to_datetime).to eq shopify_image.created_at.to_datetime
    end

    it 'updated at' do
      expect(spree_image.updated_at.to_datetime).to eq shopify_image.updated_at.to_datetime
    end
  end
end
