require 'spec_helper'

describe RequestProvenance do
  describe '.authorized?' do
    before(:each) do
      @timestamp = Time.now.to_i.to_s
      @path = 'http://localhost:3000/verification'
      @uri = @path + "?timestamp=#{@timestamp}"
      @signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), ENV['ELEFEELY_SECRET'], @uri)

      @params = { path: @path, params: { timestamp: @timestamp, signature: @signature } }
    end

    context 'on the happy path' do
      it 'returns true with correct params and signature' do
        expect(RequestProvenance.new(@params)).to be_authorized
      end
    end

    context 'on the sad path' do
      context 'with incorrect signature' do
        it 'returns false' do
          @params.merge!({params: { signature: '123' }})

          expect(RequestProvenance.new(@params)).to_not be_authorized
        end
      end

      context 'outside of 10 seconds from timestamp' do
        it 'returns false' do
          Time.stub(:now).and_return(OpenStruct.new(to_i: @timestamp.to_i + 10))

          expect(RequestProvenance.new(@params)).to_not be_authorized
        end
      end
    end
  end
end
