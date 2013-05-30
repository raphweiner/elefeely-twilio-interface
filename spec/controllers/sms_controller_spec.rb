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
end

