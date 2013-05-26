require 'spec_helper'

describe SmsController do
  describe 'POST #create' do
    before(:each) do
      @params ||= YAML.load_file(Rails.root.join('spec/support', 'twilio_callback.yml'))
    end

    context 'happy path' do
      it 'creates request to Elefeely API' do
        feely_mock = mock('feely')
        feely_mock.stub(:message)
        Feely.should_receive(:new_and_send).and_return(feely_mock)

        post :create, @params
      end

      it 'returns with appropriate response' do
        post :create, @params

        expect(response.body).to eq "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n  <Sms>Great to hear!</Sms>\n</Response>\n"
      end
    end
  end
end

