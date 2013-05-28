class ElefeelyAPI
  def self.phone_numbers
    response_body = JSON.parse(request.body)

    response_body['phone_numbers']
  end

private

  def self.request
    ::Faraday.get("http://elefeely-api.herokuapp.com/phones/verified")
  end
end
