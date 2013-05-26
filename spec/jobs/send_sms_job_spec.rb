require 'spec_helper'

describe SendSmsJob do
  describe '.perform' do
    it 'instantiates a new twilio client' do
      SendSmsJob.stub(:send_sms)
      Twilio::REST::Client.should_receive(:new).with(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

      SendSmsJob.perform('1234567890')
    end

    it 'sends an sms' do
      mock_client = mock('twilio client')
      Twilio::REST::Client.stub(:new).and_return(mock_client)
      SendSmsJob.should_receive(:send_sms).with(mock_client, '1234567890')

      SendSmsJob.perform('1234567890')
    end
  end
end
