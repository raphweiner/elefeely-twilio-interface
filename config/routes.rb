ElefeelyTwilioInterface::Application.routes.draw do
  mount Resque::Server, at: "/resque"

  resource :sms, only: [ :create ]

  post '/validation' => 'sms#validate'
end
