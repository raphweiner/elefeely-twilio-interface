require 'spec_helper'

describe SendSmsJob do
  describe '.perform' do
    context 'sending a feeler type sms' do
      it 'instantiates a new twilio client' do
        SendSmsJob.stub(:feeler)
        Twilio::REST::Client.should_receive(:new).with(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

        SendSmsJob.perform(:feeler, '1234567890')
      end

      it 'sends an sms' do
        mock_client = mock('twilio client')
        Twilio::REST::Client.stub(:new).and_return(mock_client)
        SendSmsJob.should_receive(:feeler).with(mock_client, '1234567890')

        SendSmsJob.perform(:feeler, '1234567890')
      end
    end

    context 'sending a verification type sms' do
      it 'instantiates a new twilio client' do
        SendSmsJob.stub(:verification)
        Twilio::REST::Client.should_receive(:new).with(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

        SendSmsJob.perform(:verification, '1234567890')
      end

      it 'sends an sms' do
        mock_client = mock('twilio client')
        Twilio::REST::Client.stub(:new).and_return(mock_client)
        SendSmsJob.should_receive(:verification).with(mock_client, '1234567890')

        SendSmsJob.perform(:verification, '1234567890')
      end
    end
  end
end
