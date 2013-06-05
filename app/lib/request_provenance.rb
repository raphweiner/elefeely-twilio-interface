class RequestProvenance
  attr_reader :path,
              :params

  def initialize(params)
    @path = params[:path]
    @params = params[:params]
  end

  def authorized?
    valid_signature? && valid_timestamp?
  end

private

  def uri
    path + "?timestamp=#{params[:timestamp]}"
  end

  def answer
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha512'),
                            ENV['ELEFEELY_SECRET'],
                            uri)
  end

  def valid_signature?
    answer == signature
  end

  def valid_timestamp?
    (Time.now.to_i - params[:timestamp].to_i) < 10
  end

  def signature
    params[:signature]
  end
end
