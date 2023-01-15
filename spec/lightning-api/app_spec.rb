RSpec.describe LightningApi::App do
  context '.router' do
    it 'has router set' do
      expect(subject.class.router).to be_a_kind_of(Hanami::API::Router)
    end

    it 'inherited class has router set' do
      expect(Class.new(subject.class).router).to be_a_kind_of(Hanami::API::Router)
    end
  end
end
