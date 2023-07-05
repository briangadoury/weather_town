Rails.application.routes.draw do
  root to: 'current_weather#index'
  get 'current_weather/fetch', defaults: { format: 'json' }
end
