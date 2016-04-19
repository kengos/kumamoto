# Kumamoto

Web scraping tools

## Earchquake

Scraping page: http://www.data.jma.go.jp/svd/eqdb/data/shindo/index.php

JSON data LISENCE: http://www.jma.go.jp/jma/kishou/info/coment.html

Program LISENCE: MIT

Example data: https://raw.githubusercontent.com/kengos/kumamoto/master/resources/earthquake/2016/2016_04_14.json

### Usage

Generate `30.days.ago` to `5.days.ago` earthquake json data in Japan

```rb
Kumamoto::Earthquake::Client.new.start(30, 5)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kengos/kumamoto

