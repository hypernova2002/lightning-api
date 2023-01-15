RSpec.describe LightningApi::Utils::EnsureAttribute do
  subject { Class.new.include LightningApi::Utils::EnsureAttribute }

  context '.underscore' do
    it 'sets attribute if attribute does not exist' do
      expect(subject.new.respond_to?(:field)).to be false

      subject.ensure_attribute(subject, :field)

      expect(subject.new.respond_to?(:field)).to be true
    end
  end
end
