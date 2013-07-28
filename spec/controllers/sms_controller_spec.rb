require 'spec_helper'

describe SmsController do
  describe 'POST #create' do
    before(:all) do
      @params = YAML.load_file(Rails.root.join('spec/support', 'twilio_callback.yml'))
    end

    context 'user sends valid text message' do
      it 'makes POST #create feeling request to main api' do
        Elefeely.should_receive(:send_feeling)

        post :create, @params
      end

      it 'returns an appropriate response' do
        Elefeely.stub(:send_feeling)
        post :create, @params

        expect(response.body).to eq({:Sms => 'Great to hear!'}.to_xml(:root => 'Response'))
      end
    end

    context 'user sends invalid text message' do
      it 'does not make POST #create feeling request to main api' do
        Elefeely.should_not_receive(:send_feeling)

        post :create, @params.merge("Body" => "I'm invalid")
      end

      it 'returns an appropriate response' do
        post :create, @params.merge("Body" => "I'm invalid")

        expect(response.body).to eq({:Sms => 'Please enter a number 1-5'}.to_xml(:root => 'Response'))
      end
    end
  end

  describe 'POST #verify' do
    let(:phone_number) { '1234567890' }

    context 'when the request is valid' do
      before { controller.stub(authorized?: true) }

      it 'queues a verify number sms job' do
        Resque.should_receive(:enqueue).with(SendSmsJob, :verification, phone_number)

        post :verify, { number: phone_number }
      end
    end

    context 'the request signature is invalid' do
      it 'does not queue a verify number sms job' do
        Resque.should_not_receive(:enqueue)

        post :verify, { number: phone_number }
      end

      it 'responds with a 401' do
        post :verify, { number: phone_number }

        expect(response.code).to eq '401'
      end
    end
  end
end
