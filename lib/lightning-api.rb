require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.tag = 'lightning-api'
loader.inflector.inflect('lightning-api' => 'LightningApi')
loader.setup

module LightningApi
  class Error < StandardError; end
  class InferredClassError < Error; end
end
