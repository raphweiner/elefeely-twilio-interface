require 'spec_helper'

describe SendTextJob do
  describe '.perform' do
    it 'instantiates a new twilio client' do
      SendTextJob.stub(:send_sms)
      Twilio::REST::Client.should_receive(:new).with(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

      SendTextJob.perform('1234567890')
    end

    it 'sends an sms' do
      mock_client = mock('twilio client')
      Twilio::REST::Client.stub(:new).and_return(mock_client)
      SendTextJob.should_receive(:send_sms).with(mock_client, '1234567890')

      SendTextJob.perform('1234567890')
    end
  end
end
