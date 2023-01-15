RSpec.describe LightningApi::Services do
  subject do
    Class.new do
      include LightningApi::Services
    end
  end

  context 'instance attributes' do
    it('has user attribute') { expect(subject.new.respond_to?(:user)).to be true }
    it('has dataset attribute') { expect(subject.new.respond_to?(:dataset)).to be true }
    it('has params attribute') { expect(subject.new.respond_to?(:params)).to be true }
  end

  context 'class attributes' do
    it('has service_class attribute') { expect(subject.respond_to?(:service_class)).to be true }
  end

  context '.service' do
    let(:service_class) { 'LightningServiceClass' }

    it 'sets service_class' do
      subject.service(service_class)
      expect(subject.service_class).to eql(service_class)
    end
  end

  context '#service' do
    let(:service_class) { 'LightningServiceClass' }

    it 'returns service_class' do
      subject.service(service_class)
      expect(subject.new.service).to eql(service_class)
    end
  end

  context '#call_service' do
    let(:service_class) { LightningApi::Service }
    let(:service) { instance_double(LightningApi::Service) }
    let(:user) { 'LightningUser' }
    let(:dataset) { 'LightningDataset' }
    let(:params) { { id: 1 } }

    it 'correctly calls service' do
      expect(service_class).to receive(:new).with(user:, dataset:).and_return(service)
      expect(service).to receive(:call).with(params:).and_return(params)

      subject.service(service_class)
      action = subject.new.tap do |a|
        a.instance_variable_set('@user', user)
        a.instance_variable_set('@dataset', dataset)
        a.instance_variable_set('@params', params)
      end

      expect(action.call_services).to eql(params)
    end
  end
end
