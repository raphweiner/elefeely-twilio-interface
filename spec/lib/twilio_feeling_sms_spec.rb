require 'spec_helper'

describe TwilioFeelingSMS do
  before(:all) do
    @params = YAML.load_file(Rails.root.join('spec/support', 'twilio_callback.yml'))
  end

  subject do
    TwilioFeelingSMS.new(@params)
  end

  describe '.valid?' do
    it 'is valid with correct params' do
      expect(TwilioFeelingSMS.new(@params)).to be_valid
    end

    it 'requires an sms_sid' do
      expect(TwilioFeelingSMS.new(@params.merge('SmsSid' => nil))).to_not be_valid
    end

    it 'requires a from' do
      expect(TwilioFeelingSMS.new(@params.merge('From' => nil))).to_not be_valid
    end

    it 'requires a valid body between 1-5' do
      expect(TwilioFeelingSMS.new(@params.merge('Body' => 'hello'))).to_not be_valid
      expect(TwilioFeelingSMS.new(@params.merge('Body' => '6'))).to_not be_valid
    end
  end

  describe '.response_xml' do
    def xml_response(message)
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n  <Sms>#{message}</Sms>\n</Response>\n"
    end

    it 'responds with the correct message when body is 5' do
      sms_message = TwilioFeelingSMS.new(@params)
      expect(sms_message.response_xml).to eq xml_response('Great to hear!')
    end

    it 'responds with the correct message when body is 4' do
      sms_message = TwilioFeelingSMS.new(@params.merge('Body' => '4'))
      expect(sms_message.response_xml).to eq xml_response('Nice!')
    end

    it 'responds with the correct message when body is 3' do
      sms_message = TwilioFeelingSMS.new(@params.merge('Body' => '3'))
      expect(sms_message.response_xml).to eq xml_response('Gotcha. Hope something exciting happens.')
    end

    it 'responds with the correct message when body is 2' do
      sms_message = TwilioFeelingSMS.new(@params.merge('Body' => '2'))
      expect(sms_message.response_xml).to eq xml_response('Ok, rest up!')
    end

    it 'responds with the correct message when body is 1' do
      sms_message = TwilioFeelingSMS.new(@params.merge('Body' => '1'))
      expect(sms_message.response_xml).to eq xml_response('Sorry to hear it :(')
    end

    it 'responds with the correct message when body is invalid' do
      sms_message = TwilioFeelingSMS.new(@params.merge('Body' => 'invalid'))
      expect(sms_message.response_xml).to eq xml_response('Please enter a number 1-5')
    end
  end
end
