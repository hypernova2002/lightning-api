module LightningApi
  class Service
    attr_reader :user, :dataset

    def initialize(user: nil, dataset: nil)
      @user = user
      @dataset = dataset
    end

    def call(params: nil) = dataset
  end
end
