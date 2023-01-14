# Lightning Api

Lightning Api is a highly opinionated api, simplifying api development by removing a lot of boiler plate code.

This library uses it's own design pattern for writing apis. Whilst a typical pattern might be MVC, Lightning Api uses a pipeline pattern. When request has arrives at the controller, the controller or service will need to fetch the required resources specified by the request parameters, perform various actions on those resources and then return a response. This process is often repetitive across routes, so many apis write their own middleware or callback abstraction layer. The problem is that this is often repeated for every project and each project has to try and solve the same problem. Lightning Api tries to solve this problem once, so every project has the basic api process in place.

A typical flow for a GET route might be

- Fetch resources based on the url parameters
- Perform filtering and sorting based on query string parameters
- Paginate results
- Convert the results into resources
- Serialise resources into JSON

This can be easily encapsulated into an abstract list action pipeline.

```ruby
module ExampleApi
  class ListAction < LightningApi::Action
    pipeline :datasets, :resolvers, :services, :pagination, :resources
  end
end
```

Then any list action can be created by inheriting the abstract list action and setting up some configuration.

```ruby
module ExampleApi
  module Actions
    module ExampleController
      class List < ExampleApi::ListAction
        default_dataset ExampleModel
        service ExampleFilterService
        resource ExampleResource
      end
    end
  end
end
```

Whenever the ExampleController::List action is invoked, the ExampleModel class will be passed into the ExampleFilterService with the request params. Your ExampleFilterService will need to handle the filtering and return a dataset. Pagination will be applied to the dataset and passed into the ExampleResource. ExampleResource will turn the dataset into a response object, which will be passed back to the application middleware.

Controller actions are now just a matter of configuration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lightning-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lightning-api

## Dependencies

|Library|Description|
|-------:|-----------|
|[Rack](https://github.com/rack/rack)|A modular interface for middleware|
|[Zeitwerk](https://github.com/fxn/zeitwerk)|Library for loading code|
|[Hanami Api](https://github.com/hanami/api)|Fast api framework|
|[Sequel](https://github.com/jeremyevans/sequel)|ORM and database adapter|
|[Puma](https://github.com/puma/puma)|Web server|
|[Alba](https://github.com/okuramasafumi/alba)|Resource serialization|
|[Pagy](https://github.com/ddnexus/pagy)|Pagination|
|[Oj](https://github.com/ohler55/oj)|JSON serializer|
|[Guard](https://github.com/guard/guard)|Code reloader|

## Usage

### Create an app

```ruby
# example-api/app.rb

require 'lightning-api'

module ExampleApi
  class App < LightningApi::App
    get '/', to: Example::Actions::Home::Show
  end
end
```

The library uses the zeitwerk gem for resolving constants, so the modules and namespaces will need to be placed in the appropriate zeitwerk file path convention.

### Create an action

```ruby
# example-api/actions/home/show.rb

module ExampleApi
  module Actions
    module Home
      class Show < LightningApi::Action
      end
    end
  end
end
```

If you need more information, then you can find example applications in the examples folder. These applications should contain enough information for building a basic api.

## Rake Tasks

The library is equipped with some rake tasks for managing your application. Add the following to your Rakefile.

```ruby
# Rakefile

require 'lightning-api/rake_tasks'
```

List all the available rake tasks.

    $ bundle exec rake -T


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hypernova2002/lightning-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Lightning Api project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/lightning-api/blob/master/CODE_OF_CONDUCT.md).
