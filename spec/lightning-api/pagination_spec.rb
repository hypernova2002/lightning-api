RSpec.describe LightningApi::Pagination do
  subject do
    Class.new do
      include LightningApi::Pagination
    end
  end

  context 'instance attributes' do
    it('has request attribute') { expect(subject.new.respond_to?(:request)).to be true }
    it('has dataset attribute') { expect(subject.new.respond_to?(:dataset)).to be true }
    it('has params attribute') { expect(subject.new.respond_to?(:params)).to be true }
    it('has headers attribute') { expect(subject.new.respond_to?(:headers)).to be true }
  end

  context '#call_pagination' do
    let(:pagy) { 'LightningPagy' }
    let(:dataset) { 'LightningDataset' }
    let(:headers) { { accept: 'application_json' } }
    let(:pagination) do
      subject.new.tap do |s|
        s.instance_variable_set('@dataset', dataset)
      end
    end

    it 'calls pagy and pagy_headers' do
      expect(pagination).to receive(:pagy).with(dataset).and_return([pagy, dataset])
      expect(pagination).to receive(:pagy_headers).with(pagy).and_return(headers)

      pagination.call_pagination

      expect(pagination.headers).to eql(headers)
    end
  end
end
