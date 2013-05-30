ElefeelyTwilioInterface::Application.routes.draw do
  mount Resque::Server, at: "/resque"

  resource :sms, only: [ :create ]

  post '/validate_number' => 'sms#validate'
end
