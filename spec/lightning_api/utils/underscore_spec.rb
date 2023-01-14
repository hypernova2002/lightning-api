RSpec.describe LightningApi::Utils::Underscore do
  subject { Class.new.include LightningApi::Utils::Underscore }

  context '.underscore' do
    let(:snake_case_string) { 'snake_case_string' }
    let(:camel_case_string) { 'CamelCaseString' }

    it 'returns empty for empty string' do
      expect(subject.underscore('')).to be_empty
    end

    it 'returns empty for nil class' do
      expect(subject.underscore(nil)).to be_empty
    end

    it 'does nothing for snake case string' do
      expect(subject.underscore(snake_case_string)).to eql(snake_case_string)
    end

    it 'converts camel case to snake case' do
      expect(subject.underscore(camel_case_string)).to eql('camel_case_string')
    end
  end
end
