RSpec.describe LightningApi::Resources do
  subject do
    Class.new do
      include LightningApi::Resources
    end
  end

  context 'instance attributes' do
    it('has user attribute') { expect(subject.new.respond_to?(:user)).to be true }
    it('has dataset attribute') { expect(subject.new.respond_to?(:dataset)).to be true }
  end

  context 'class attributes' do
    it('has resource_class attribute') { expect(subject.respond_to?(:resource_class)).to be true }
  end

  context '.resource' do
    let(:resource_class) { 'LightningResourceClass' }

    it 'sets resource_class' do
      subject.resource(resource_class)
      expect(subject.resource_class).to eql(resource_class)
    end
  end

  context 'instance_methods' do
    let(:resource_class) { LightningApi::Resource }
    let(:resource) { instance_double(LightningApi::Resource) }
    let(:user) { 'LightningUser' }
    let(:dataset) { 'LightningDataset' }

    context '#resource' do
      it 'returns resource_class' do
        subject.resource(resource_class)
        expect(subject.new.resource).to eql(resource_class)
      end
    end

    context '#call_resources' do
      it 'returns nil for nil dataset' do
        expect(resource_class).not_to receive(:new)
        subject.resource(resource_class)
        action = subject.new.tap do |a|
          a.instance_variable_set('@user', user)
        end

        expect(action.call_resources).to be_nil
      end

      it 'calls resources with correct parameters' do
        expect(resource_class).to receive(:new).with(dataset,
                                                     params: { user: }).and_return(resource)
        expect(resource).to receive(:serialize).and_return(dataset)
        subject.resource(resource_class)
        action = subject.new.tap do |a|
          a.instance_variable_set('@user', user)
          a.instance_variable_set('@dataset', dataset)
        end

        expect(action.call_resources).to eql(dataset)
      end

      it 'calls inline_serialize when there are no configured resources' do
        subject.resource(nil)
        action = subject.new.tap do |a|
          a.instance_variable_set('@user', user)
          a.instance_variable_set('@dataset', dataset)
        end

        expect(action).to receive(:inline_serialize).and_return(dataset)

        expect(action.call_resources).to eql(dataset)
      end
    end

    context '#datatype_map' do
      it 'returns datetime formatter for Time' do
        datatype, type_formatter = subject.new.send(:datatype_map, Time.new)

        expect(datatype).to eql(String)
        expect(type_formatter.call(Time.new(2023, 1, 4, 12, 50, 30))).to eql('2023-01-04 12:50:30')
      end

      it 'returns nil for NilClass' do
        datatype, type_formatter = subject.new.send(:datatype_map, nil)

        expect(datatype).to eql(String)
        expect(type_formatter.call(nil)).to be_nil
      end

      it 'returns true for all other classes' do
        datatype, type_formatter = subject.new.send(:datatype_map, 1)

        expect(datatype).to eql(Integer)
        expect(type_formatter).to be true
      end
    end

    context '#inline_serialize' do
      let(:time_dataset) do
        OpenStruct.new(columns: %i[timestamp], timestamp: Time.new(2023, 5, 7, 18, 15, 20))
      end
      let(:nil_dataset) { OpenStruct.new(columns: %i[nil_field], nil_field: nil) }
      let(:integer_dataset) { OpenStruct.new(columns: %i[integer], integer: 3) }

      it 'correctly serializes Time' do
        expect(subject.new.send(:inline_serialize,
                                time_dataset)).to eql({ timestamp: '2023-05-07 18:15:20' }.to_json)
      end

      it 'correctly serializes NilClass' do
        expect(subject.new.send(:inline_serialize, nil_dataset)).to eql({ nil_field: nil }.to_json)
      end

      it 'correctly serializes Integer' do
        expect(subject.new.send(:inline_serialize, integer_dataset)).to eql({ integer: 3 }.to_json)
      end

      it 'correctly serializes when dataset is an array' do
        expect(subject.new.send(:inline_serialize,
                                [integer_dataset])).to eql([{ integer: 3 }].to_json)
      end
    end
  end
end
