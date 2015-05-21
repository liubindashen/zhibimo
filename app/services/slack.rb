class Slack
  def self.send(message) 
    conn = Faraday.new(:url => 'https://hooks.slack.com') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    payload = {
      channel:    '#zhibimo',
      username:   'luxun',
      icon_emoji: ':luxun:',
      text:       message
    }

    conn.post do |req|
      req.url '/services/T0250NGVD/B04GKDC3Y/vMryc2m2t1BzgFT3CXUpqd8O'
      req.headers['Content-Type'] = 'application/json'
      req.body = JSON.dump(payload)
    end
  end
end
