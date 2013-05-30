class RequestProvenance
  attr_reader :path,
              :params

  def initialize(params)
    @path = params[:path]
    @params = params[:params]
  end

  def authorized?
    answer == signature && (Time.now.to_i - params[:timestamp].to_i) < 10
  end

private

  def uri
    path + "?timestamp=#{params[:timestamp]}"
  end

  def answer
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'),
                            ENV['ELEFEELY_SECRET'],
                            uri)
  end

  def signature
    params[:signature]
  end
end
