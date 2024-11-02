def connection
    @connection ||= Faraday.new(url: 'https://httpbingo.org') do |builder|
    builder.request :authorization, 'Bearer', -> { MyAuthStorage.get_auth_token }
    builder.request :json
    builder.response :json
    builder.response :raise_error
    builder.response :logger
  end
end

def request
  begin
    response = connection.post('post', { payload: 'this ruby hash will become JSON' })
    puts response.status
    puts response.body
    puts JSON.pretty_generate(response.body)
  rescue Faraday::Error => e
    # You can handle errors here (4xx/5xx responses, timeouts, etc.)
    puts e.response[:status]
    puts e.response[:body]
  end
end

class MyAuthStorage
  def self.get_auth_token
    rand(36 ** 8).to_s(36)
  end
end