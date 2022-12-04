class ExchangeRatesController < ApplicationController
  def fetch
    render json: {
      'USD' => BitfinexApi.exchange_rate_of('BTC', 'USD').to_f
    }.to_json
  end
end
