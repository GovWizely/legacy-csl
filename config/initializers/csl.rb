require 'hashie'
require 'yaml'

Rails.configuration.csl = ::Hashie::Mash.load(Rails.root.join('config/csl.yml'))[Rails.env]
