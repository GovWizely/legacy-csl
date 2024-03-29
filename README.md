Consolidated Screening List
==============

# Installation

### Ruby

You'll need [Ruby 2.2](http://www.ruby-lang.org/en/downloads/).

### Gems

We use bundler to manage gems. You can install bundler and other required gems like this:

    gem install bundler
    bundle install
    
The `charlock_holmes` gem requires the UCI libraries to be installed. If you are using Homebrew, it's probably as simple as this:
     
     brew install icu4c

More information about the gem can be found [here](https://github.com/brianmario/charlock_holmes)             

### ElasticSearch

We're using [ElasticSearch](http://www.elasticsearch.org/) (>= 5.2.2) for fulltext search. On a Mac, it's easy to install with [Homebrew](http://mxcl.github.com/homebrew/).

    brew install elasticsearch

Otherwise, follow the [instructions](http://www.elasticsearch.org/download/) to download and run it.

### Redis

You'll need to have redis installed on your machine. `brew install redis`, `apt-get install redis-server`, etc.

### Configuration

Copy config/csl.yml.example to config/csl.yml and edit if necessary.

### Running it

Create the indexes:

    bundle exec rake db:create
    
Fire up a server:

    bundle exec rails s
    
Import some data:

    bundle exec rake ita:import[ScreeningList]

Admin users can log in and monitor the progress of the Sidekiq import jobs via `/sidekiq`.

#### Examples

<http://localhost:3000/consolidated_screening_list/search?size=5&offset=8>

<http://localhost:3000/consolidated_screening_list/search?q=john>

<http://localhost:3000/consolidated_screening_list/search?sources=SDN,EL>

### Specs

    bundle exec rspec

Elasticsearch must be running. 

### Code Coverage

We track test coverage of the codebase over time to help identify areas where we could write better tests and to see when poorly tested code got introduced.

After running your tests, view the report by opening `coverage/index.html`.

Click around on the files that have less than 100% coverage to see what lines weren't exercised.

### Code Status

* [![Build Status](https://travis-ci.org/GovWizely/csl.svg?branch=master)](https://travis-ci.org/GovWizely/csl/)
* [![Code Climate](https://codeclimate.com/github/GovWizely/csl/badges/gpa.svg)](https://codeclimate.com/github/GovWizely/csl)
* [![Test Coverage](https://codeclimate.com/github/GovWizely/csl/badges/coverage.svg)](https://codeclimate.com/github/GovWizely/csl/coverage)
