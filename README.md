# Paginae
[![Ruby](https://github.com/3zcurdia/paginae/actions/workflows/main.yml/badge.svg)](https://github.com/3zcurdia/paginae/actions/workflows/main.yml)

Yes! another Page Object DSL, but this time I promise to keep it simple for the user.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paginae'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install paginae

## Usage

Just include the Web module into your ruby object

```ruby
class ProductPage
  include Paginae::Web

  attribute :name, id: "product-title"
  attribute :model, xpath: "//h2[@class='product-model']"
  attribute :summary, css: "#product-overview"
  attribute :image_url, css: "#product-image", value: :src
  attribute :colors, css: ".product-colors li" listed: true
  attribute :sizes, css: ".product-sizes" listed: -> { |e| e.text.split(', ') }
  attribute :prices, css: ".product-price", mapped: ->(price) { ["USD", price.text.gsub(/[^\d\.]/, '').to_f] }
  attribute :specs, css: "#productSpecs li", mapped: :map_specs

  private

  def map_specs(node)
    [node.text.gsub(/\s+/, " ")&.strip, node.attribute("data-spec")&.value]]
  end
end
```

And once its defined, you can use it like this:

```ruby
  product = ProductPage.new(your_http_body_content)
  product.name
  product.model
  product.summary
  product.colors
  product.sizes
  product.price
  product.specs
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/3zcurdia/paginae. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/3zcurdia/paginae/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Paginae project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/3zcurdia/paginae/blob/main/CODE_OF_CONDUCT.md).
