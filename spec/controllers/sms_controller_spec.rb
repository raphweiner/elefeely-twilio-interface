require 'spec_helper'

describe SmsController do
  describe 'POST #create' do
    before(:each) do
      @params ||= YAML.load_file(Rails.root.join('spec/support', 'twilio_callback.yml'))
    end

    context 'happy path' do

      let(:sms) do
        {'5' => 'Great to hear!',
         '4' => 'Nice!',
         '3' => 'Gotcha. Hope something exciting happens.',
         '2' => 'Ok, rest up!',
         '1' => 'Sorry to hear it :('
        }
      end

      it 'creates request to Elefeely API' do
        feely_mock = mock('feely')
        feely_mock.stub(:message)
        Feely.should_receive(:new_and_send).and_return(feely_mock)

        post :create, @params
      end

      it 'returns with appropriate response when body is 5' do
        post :create, @params

        expect(response.body).to eq "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n  <Sms>#{sms['5']}</Sms>\n</Response>\n"
      end

      it 'returns with appropriate response when body is 4' do
        @params.merge!({"Body" => '4'})
        post :create, @params

        expect(response.body).to eq "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n  <Sms>#{sms['4']}</Sms>\n</Response>\n"
      end

      it 'returns with appropriate response when body is 3' do
        @params.merge!({"Body" => '3'})
        post :create, @params

        expect(response.body).to eq "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n  <Sms>#{sms['3']}</Sms>\n</Response>\n"
      end

      it 'returns with appropriate response when body is 2' do
        @params.merge!({"Body" => '2'})
        post :create, @params

        expect(response.body).to eq "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n  <Sms>#{sms['2']}</Sms>\n</Response>\n"
      end

      it 'returns with appropriate response when body is 1' do
        @params.merge!({"Body" => '1'})
        post :create, @params

        expect(response.body).to eq "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n  <Sms>#{sms['1']}</Sms>\n</Response>\n"
      end
    end
  end
end

