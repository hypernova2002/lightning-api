RSpec.describe LightningApi::Utils::CamelCase do
  subject { Class.new.include LightningApi::Utils::CamelCase }

  context '.camel_case' do
    let(:snake_case_string) { 'snake_case_string' }
    let(:camel_case_string) { 'CamelCaseString' }

    it 'returns empty for empty string' do
      expect(subject.camel_case('')).to be_empty
    end

    it 'returns empty for nil class' do
      expect(subject.camel_case(nil)).to be_empty
    end

    it 'does nothing for camel case string' do
      expect(subject.camel_case(camel_case_string)).to eql(camel_case_string)
    end

    it 'converts snake case to camel case' do
      expect(subject.camel_case(snake_case_string)).to eql('SnakeCaseString')
    end
  end
end
