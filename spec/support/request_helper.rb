module Requests
  module JsonHelpers
    def json
      JSON.parse(last_response.body)
    end
    def data
      json['data']
    end
  end
end