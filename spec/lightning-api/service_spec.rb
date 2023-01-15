RSpec.describe LightningApi::Service do
  subject { described_class.new(user:, dataset:) }

  let(:user) { 'LightningUser' }
  let(:dataset) { 'LightningDataset' }
  let(:params) { { id: 1 } }

  context '#user' do
    it('sets user') { expect(subject.user).to eql(user) }
  end

  context '#dataset' do
    it('sets dataset') { expect(subject.dataset).to eql(dataset) }
  end

  context '#call' do
    it('returns dataset without params') do
      expect(subject.call).to eql(dataset)
    end

    it('returns dataset with params') do
      expect(subject.call(params:)).to eql(dataset)
    end
  end
end
