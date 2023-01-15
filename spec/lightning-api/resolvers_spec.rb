RSpec.describe LightningApi::Resolvers do
  subject do
    Class.new do
      include LightningApi::Resolvers

      def halt(status, body = nil)
        throw :halt, [status, @headers, [body].compact]
      end
    end
  end

  context 'instance attributes' do
    it('has user attribute') { expect(subject.new.respond_to?(:user)).to be true }
    it('has dataset attribute') { expect(subject.new.respond_to?(:dataset)).to be true }
    # it ('has request attribute') { subject.new.respond_to?(:request) }
    it('has params attribute') { expect(subject.new.respond_to?(:params)).to be true }
  end

  context 'class attributes' do
    it('has resolver_chain attribute') { expect(subject.respond_to?(:resolver_chain)).to be true }
  end

  context '.resolver_chain' do
    let(:resolver_class) { 'LightningResolverClass' }

    it 'sets resolver_class' do
      subject.resolvers(resolver_class)
      expect(subject.resolver_chain).to contain_exactly(resolver_class)
    end

    it 'sets multiple resolver_classes' do
      subject.resolvers(resolver_class, resolver_class)
      expect(subject.resolver_chain).to contain_exactly(resolver_class, resolver_class)
    end
  end

  context '#resolvers' do
    let(:resolver_class) { 'LightningResolverClass' }

    it 'returns service_class' do
      subject.resolvers(resolver_class)
      expect(subject.new.resolver_chain).to contain_exactly(resolver_class)
    end
  end

  context '#call_resolvers' do
    let(:resolver_class) { LightningApi::Resolver }
    let(:resolver) { instance_double(LightningApi::Resolver) }
    let(:user) { 'LightningUser' }
    let(:dataset) { 'LightningDataset' }
    let(:params) { { id: 1 } }

    it 'correctly calls resolvers' do
      expect(resolver_class).to receive(:new).with(user:, dataset:).and_return(resolver)
      expect(resolver).to receive(:resolve).with(params:).and_return(params)

      subject.resolvers(resolver_class)
      action = subject.new.tap do |a|
        a.instance_variable_set('@user', user)
        a.instance_variable_set('@dataset', dataset)
        a.instance_variable_set('@params', params)
      end

      action.call_resolvers

      expect(action.dataset).to eql(params)
    end

    it 'halts 404 when resolver returns nil' do
      expect(resolver_class).to receive(:new).with(user:, dataset:).and_return(resolver)
      expect(resolver).to receive(:resolve).with(params:).and_return(nil)

      subject.resolvers(resolver_class)
      action = subject.new.tap do |a|
        a.instance_variable_set('@user', user)
        a.instance_variable_set('@dataset', dataset)
        a.instance_variable_set('@params', params)
      end

      expect { action.call_resolvers }.to throw_symbol(:halt, [404, nil, []])
    end
  end
end
