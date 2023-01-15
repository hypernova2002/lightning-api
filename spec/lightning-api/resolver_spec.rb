module LightningApi
  module Models; end
end

RSpec.describe LightningApi::Resolver do
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

  context '#resolve' do
    let(:inferable_dataset_with_method) do
      klass = Class.new do
        def inferable_dataset_with_methods_dataset = self
        def where(id:) = [id + 5]
      end

      LightningApi::Models.const_set('InferableDatasetWithMethod', klass)
    end

    let(:inferable_dataset_without_method) do
      LightningApi::Models.const_set('InferableDatasetWithoutMethod', Class.new)
    end
    let(:non_inferable_dataset) { Object.const_set('NonInferableDataset', Class.new) }

    it 'correctly calls inferable dataset with inferable method' do
      params[:inferable_dataset_with_method_id] = 3
      resolver = described_class.new(user:, dataset: inferable_dataset_with_method.new)
      expect(resolver.resolve(params:)).to eql(8)
    end

    it 'correctly calls inferable dataset with non inferable method' do
      resolver = described_class.new(user:, dataset: inferable_dataset_without_method.new)
      expect(resolver.resolve(params:)).to eql(LightningApi::Models::InferableDatasetWithoutMethod)
    end

    it 'raises InferredClassError when dataset is not inferable' do
      resolver = described_class.new(user:, dataset: non_inferable_dataset.new)
      expect { resolver.resolve(params:) }.to raise_error(LightningApi::InferredClassError)
    end

    it 'raises InferredClassError for nil dataset' do
      resolver = described_class.new(user:, dataset: nil)
      expect { resolver.resolve(params:) }.to raise_error(LightningApi::InferredClassError)
    end
  end
end
