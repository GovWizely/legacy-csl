require 'spec_helper'

describe 'Trade Events API V1', type: :request do
  include_context 'TradeEvent::Ustda data'

  describe 'GET /v1/trade_events/ustda/search.json' do
    let(:params) { { size: 100 } }
    before { get '/v1/trade_events/ustda/search', params }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ustda results'
    end

    context 'when q is specified' do
      let(:params) { { q: 'google' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ustda results that match "google"'
      it_behaves_like "an empty result when a query doesn't match any documents"
    end

    context 'when countries is specified' do
      let(:params) { { countries: 'us' } }
      it_behaves_like 'a successful search request'
      it_behaves_like "an empty result when a query doesn't match any documents"
    end
    
    context 'when industry is specified' do
      let(:params) { { industry: 'Renewable Energy' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ustda results that match industry "Renewable Energy"'
    end
  end
end
