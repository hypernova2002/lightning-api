RSpec.describe LightningApi::Pipeline do
  subject do
    Class.new do
      include LightningApi::Pipeline
    end
  end

  context 'class attributes' do
    it ('has pipeline_performers attribute') { expect(subject.respond_to?(:pipeline_performers)).to be true }
  end

  context '.pipeline' do
    let(:set_pipeline_module) { Module.new }

    it 'sets pipeline_module' do
      Object.const_set('SetPipelineModule', set_pipeline_module)
      subject.pipeline(:set_pipeline_module)

      expect(subject.pipeline_performers).to contain_exactly(:set_pipeline_module)
      expect(subject.new).to be_a_kind_of(SetPipelineModule)
    end

    it 'sets multiple pipeline_modules' do
      Object.const_set('SetMultiplePipelineModule', set_pipeline_module)
      subject.pipeline(:set_multiple_pipeline_module, :set_multiple_pipeline_module)
      expect(subject.pipeline_performers).to contain_exactly(:set_multiple_pipeline_module, :set_multiple_pipeline_module)
    end
  end

  context '#performers' do
    let(:performer_module) { Module.new }

    it 'returns pipeline performers' do
      Object.const_set('PerformerModule', performer_module)
      subject.pipeline(:performer_module)
      expect(subject.new.send(:performers)).to contain_exactly(:performer_module)
    end
  end

  context '#run_pipeline' do
    let(:run_pipeline_module) { Module.new { def call_run_pipeline_module; end } }

    it 'calls call_:performer_name on performers' do
      Object.const_set('RunPipelineModule', run_pipeline_module)
      subject.pipeline(:run_pipeline_module)
      pipeline = subject.new

      expect(pipeline).to receive(:call_run_pipeline_module)

      pipeline.run_pipeline
    end
  end
end
