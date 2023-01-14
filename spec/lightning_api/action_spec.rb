require 'rack'

RSpec.describe LightningApi::Action do
  context 'dependencies' do
    it { is_expected.to be_a_kind_of(LightningApi::Pipeline) }

    context 'pipelines' do
      it { is_expected.to be_a_kind_of(LightningApi::Datasets) }
      it { is_expected.to be_a_kind_of(LightningApi::Resolvers) }
      it { is_expected.to be_a_kind_of(LightningApi::Services) }
      it { is_expected.to be_a_kind_of(LightningApi::Resources) }
    end
  end

  context '#halt' do
    let(:headers) { { accept: 'application/json' } }
    let(:body) { 'not found' }
    let(:status) { 404 }

    it 'correctly throws an error with body' do
      subject.instance_variable_set("@headers", headers)

      expect { subject.halt(status, body) }.to throw_symbol(:halt, [status, headers, [body]])
    end

    it 'correctly throws an error without body' do
      subject.instance_variable_set("@headers", headers)

      expect { subject.halt(status) }.to throw_symbol(:halt, [status, headers, []])
    end
  end

  context '#call' do
    let(:env) { 'ActionEnv' }
    let(:router_params) { 'RouterParams' }
    let(:request_params) { 'RequestParams' }

    let(:rack_request) do
      instance_double(Rack::Request,
        env: { 'router.params' => router_params },
        params: request_params
      )
    end

    before(:each) do
      allow(subject).to receive(:rack_request).with(env).and_return(rack_request)
    end

    it 'runs pipeline and return correct rack response' do
      expect(subject).to receive(:run_pipeline)

      expect(subject.call(env)).to contain_exactly(200, {}, [])
      expect(subject.params).to eql(router_params)
    end

    it 'uses request params when env router params are not set' do
      rack_request.env['router.params'] = nil

      expect(subject).to receive(:run_pipeline)

      expect(subject.call(env)).to contain_exactly(200, {}, [])
      expect(subject.params).to eql(request_params)
    end
  end

  context 'inherited_class' do
    subject { Class.new(LightningApi::Action).new }

    context 'methods' do
      it('has dataset method') { expect(subject.respond_to?(:dataset)).to be true }
      it('has request method') { expect(subject.respond_to?(:request)).to be true }
      it('has params method') { expect(subject.respond_to?(:params)).to be true }
      it('has halt method') { expect(subject.respond_to?(:halt)).to be true }
      it('has call method') { expect(subject.respond_to?(:call)).to be true }
      it('has rack_request method') { expect(subject.respond_to?(:rack_request)).to be true }
      it('has run_pipeline method') { expect(subject.respond_to?(:run_pipeline)).to be true }
    end

    context 'dependencies' do
      it { is_expected.to be_a_kind_of(LightningApi::Pipeline) }
  
      context 'pipelines' do
        it { is_expected.to be_a_kind_of(LightningApi::Datasets) }
        it { is_expected.to be_a_kind_of(LightningApi::Resolvers) }
        it { is_expected.to be_a_kind_of(LightningApi::Services) }
        it { is_expected.to be_a_kind_of(LightningApi::Resources) }
      end
    end
  
    context '.call' do
      let(:env) { 'ActionEnv' }
      let(:response) { 'ActionResponse' }


      it 'creates new instance and calls call' do
        expect_any_instance_of(subject.class).to receive(:call).with(env).and_return(response)

        expect(subject.class.call(env)).to eql(response)
      end
    end
  end
end
