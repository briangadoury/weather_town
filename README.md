

# README

README for Brian Gadoury's <$firstname$lastname @ gmail.com> weather API demo Rails app for BTS interview process

## Caveats

* The UI and JS code are "throw out the POC code after the project gets greenlit" levels of bad. I haven't done much of any front-end work in a few years.

* The remaining code is pretty solid, IMO. I aimed for production-level extensibility without going overboard in what is a small demo app. Example: Assume we'll eventually want to change to a different (or multiple) weather API providers, so minimize the future cost of that. I did not spend time on things that would be helpful to have, but would normally depend a lot on how the rest of the app already did things. Examples: Supporting "street, city, state" input, a user-friendly UX, error handling in the front-end, etc.

* The back-end caches its calls to external weather APIs with a 5 second expiration instead of the requested 30 minutes to help evaluators see the "was result cached?" flag working.

* All "TODO" comments are things that I would expect to be done before this code got merged into production in a real life situation. I don't like to see TODO comments get merged into main because they never seem to get revisited.

* I wanted to implement a second WeatherApi::Provider to show how easy that would be, but I didn't have time.

## Fun Facts

* Things likely to change were made easy to change. Examples:
* * Only WeatherApi::Providers::Base knows how to fetch an API key.
* * Only individual WeatherApi::Providers::Base subclasses know what their API key is called, how to call their API with auth, map the results into our standardized format, etc.
* * The WeatherApi::Query is very simple now. I'd expect that to grow over time as we added support for querying on other fields such as lat/long, city name, etc. Wrapping those params in a Query object now reduces the number of other things that would need to change. Note that zipcode support is still fairly hard-coded at the moment.
* I do not cache weather provider API responses if they are unsuccessful, but _some_ classes of them would be in real life.
* Cache key cardinality considerations when caching on zip code: Currently there are about 42,000 5-digit zip codes in the US and that number is growing very slowly. One source says there are 47 million zip+4 zip codes in the US. If our infra needed us to, we could constrain the total cache keys if we use the 5-digit code even for a zip+4 request. However, that introduces the risk of displaying the wrong city name, etc. In general, I'd be concerned about a less experienced developer adding lat/long support, caching on the lat/long value and blowing up our cache key cardinality.
* There's certainly some non-DRY code in the tests. I try to be a very DRY developer but I've found tests are much harder to read/change when they are 100% DRY-ed up.

## Installation

* Install Ruby 2.7
* Install Node
* Install Yarn
* bundle install
* * If mimemagic build fails with the classic FREEDESKTOP_PLACEHOLDER error, try `brew install shared-mime-info` and then re-run `bundle install`
* Copy .env.template to .env and add a working weatherapi.com API key. I'll ask the recruiter to forward my (free tier) key for you to use.

## Tests
* Run `rspec`

## Usage:

* Run `rails s`
* Go to http://localhost:3000/
* Enter a valid 5-digit or zip+4 zip code and click Get Weather Details.
* Hire me and let's build some killer stuff.

