class Api::V1::ScreeningLists::FseController < ApplicationController
  include Searchable
  search_by :countries, :q, :sdn_type
end
