class ExchangeRatesController < ApplicationController
  BITFINEX_EXCHANGE_RATE_URL = 'https://api.bitfinex.com/v2/calc/fx'.freeze

  def fetch
    render json: {
      'USD' => BitfinexApi.exchange_rate_of('BTC', 'USD').to_f
    }.to_json
  end
end
