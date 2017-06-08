Webservices::Application.routes.draw do
  concern :api_routable do
    get 'consolidated_screening_list/search', to: 'consolidated#search', defaults: { format: :json }
  end

  scope module: 'api/v2/screening_lists' do
    concerns :api_routable

    scope 'v2' do
      concerns :api_routable
    end
  end

  match '404', via: :all, to: 'api#not_found'
end
