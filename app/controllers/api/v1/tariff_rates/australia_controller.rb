class Api::V1::TariffRates::AustraliaController < ApplicationController
  include Searchable
  search_by :countries, :q
end