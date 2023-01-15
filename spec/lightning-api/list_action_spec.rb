require 'rack'

RSpec.describe LightningApi::ListAction do
  context 'dependencies' do
    it { is_expected.to be_a_kind_of(LightningApi::Pipeline) }

    context 'pipelines' do
      it { is_expected.to be_a_kind_of(LightningApi::Datasets) }
      it { is_expected.to be_a_kind_of(LightningApi::Resolvers) }
      it { is_expected.to be_a_kind_of(LightningApi::Services) }
      it { is_expected.to be_a_kind_of(LightningApi::Pagination) }
      it { is_expected.to be_a_kind_of(LightningApi::Resources) }
    end
  end

  context 'inherited_class' do
    subject { Class.new(LightningApi::ListAction).new }

    context 'dependencies' do
      it { is_expected.to be_a_kind_of(LightningApi::Pipeline) }

      context 'pipelines' do
        it { is_expected.to be_a_kind_of(LightningApi::Datasets) }
        it { is_expected.to be_a_kind_of(LightningApi::Resolvers) }
        it { is_expected.to be_a_kind_of(LightningApi::Services) }
        it { is_expected.to be_a_kind_of(LightningApi::Pagination) }
        it { is_expected.to be_a_kind_of(LightningApi::Resources) }
      end
    end
  end
end
