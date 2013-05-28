require 'spec_helper'

describe ElefeelyAPIRequest do
  describe '.phone_numbers' do
    it 'should return verified numbers from the elfeely-api endpoint' do
      VCR.use_cassette 'verified_phone_numbers' do
        expect(ElefeelyAPIRequest.phone_numbers).to eq ['4157455607']
      end
    end
  end
end
