RSpec.describe LightningApi::Datasets do
  subject do
    Class.new do
      include LightningApi::Datasets
    end
  end

  context 'instance attributes' do
    it('has dataset attribute') { expect(subject.new.respond_to?(:dataset)).to be true }
  end

  context 'class attributes' do
    it('has dataset attribute') { expect(subject.respond_to?(:dataset)).to be true }
  end

  context '.default_dataset' do
    let(:dataset_class) { 'LightningDatasetClass' }

    it 'sets dataset_class' do
      subject.default_dataset(dataset_class)
      expect(subject.dataset).to eql(dataset_class)
    end
  end

  context '#call_datasets' do
    let(:dataset_class) { 'LightningDatasetClass' }

    it 'sets dataset_class when default_dataset is set' do
      subject.default_dataset(dataset_class)
      dataset = subject.new
      dataset.call_datasets

      expect(dataset.dataset).to eql(dataset_class)
    end

    it 'does not set dataset when dataset_class is not set' do
      dataset = subject.new
      dataset.instance_variable_set('@dataset', dataset_class)
      dataset.call_datasets

      expect(dataset.dataset).to eql(dataset_class)
    end
  end
end
