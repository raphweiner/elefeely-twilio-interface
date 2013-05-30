require 'spec_helper'

describe SmsController do
  describe 'POST #create' do
    before(:all) do
      @params = YAML.load_file(Rails.root.join('spec/support', 'twilio_callback.yml'))
    end

    context 'happy path' do
      it 'creates request to Elefeely API' do
        Elefeely.should_receive(:send_feeling)

        post :create, @params
      end

      it 'returns an appropriate response' do
        Elefeely.stub(:send_feeling)
        post :create, @params

        expect(response.body).to eq "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n  <Sms>Great to hear!</Sms>\n</Response>\n"
      end
    end

    context 'sad path' do
      it 'creates request to Elefeely API' do
        Elefeely.should_not_receive(:send_feeling)

        post :create, @params.merge("Body" => "I'm invalid")
      end

      it 'returns an appropriate response' do
        post :create, @params.merge("Body" => "I'm invalid")

        expect(response.body).to eq "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n  <Sms>Please enter a number 1-5</Sms>\n</Response>\n"
      end
    end
  end

  describe 'POST #verify' do
    context 'the request is valid' do
      it 'queues a verify number job' do
        controller.stub(authorized?: true)
        Resque.should_receive(:enqueue).with(SendSmsJob, :verification, '1234567890')

        post :verify, { number: '1234567890' }
      end
    end

    context 'the request signature is invalid' do
      it 'does not queue verify number job' do
        Resque.should_not_receive(:enqueue).with(SendSmsJob, :verification, '1234567890')

        post :verify, { number: '1234567890' }
      end

      it 'responds with a 401' do
        post :verify, { number: '1234567890' }

        expect(response.code).to eq '401'
      end
    end
  end
end
