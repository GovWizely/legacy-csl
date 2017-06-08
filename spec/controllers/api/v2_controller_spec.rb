require 'spec_helper'

describe Api::V2Controller, type: :controller do
  class InheritsFromApiV2Controller < described_class
    def foo
      render text: 'ok', status: :ok
    end

    def bad_date_range
      raise Exceptions::InvalidDateRangeFormat
    end
  end

  describe InheritsFromApiV2Controller do
    before do
      Rails.application.routes.draw do
        get '/foo' => 'inherits_from_api_v2#foo'
        get '/bad_date_range' => 'inherits_from_api_v2#bad_date_range'
      end
    end
    after { Rails.application.reload_routes! }

    context 'with invalid date range exception' do
      it 'responds with 400 error' do
        get :bad_date_range
        expect(response.status).to eq(400)
      end
    end
  end
end
