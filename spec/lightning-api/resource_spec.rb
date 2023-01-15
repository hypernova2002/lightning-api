RSpec.describe LightningApi::Resource do
  subject { described_class.new(nil) }

  context 'included modules' do
    it { is_expected.to be_a_kind_of(Alba::Resource) }
  end
end
