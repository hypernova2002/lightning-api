module LightningApi
  class ListAction < Action
    pipeline :datasets, :resolvers, :services, :pagination, :resources
  end
end
