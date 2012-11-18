require 'oauth'
require 'json'
require 'date'

class Twavs

  attr_accessor :year, :mon, :screen_name, :favs, :oauth_token, :oauth_token_secret

  # Exchange your oauth_token and oauth_token_secret for an AccessToken instance.
  def prepare_access_token(oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new(
      "EFSeTUtEoOHdhlL4qg", "JNUeefhAv9avuedoriXRGTNRwUYE1TYRcPUpU8sU",
      { :site => "http://api.twitter.com",
        :scheme => :header
      })
    # now create the access token object from passed values
    token_hash = { :oauth_token => oauth_token,
                   :oauth_token_secret => oauth_token_secret
                 }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
    return access_token
  end

  def initialize(year, mon, screen_name, oauth_token, oauth_token_secret)
    @year = year
    @mon = mon
    @screen_name = screen_name
    @oauth_token = oauth_token
    @oauth_token_secret = oauth_token_secret
    @favs = []

    # Exchange our oauth_token and oauth_token secret for the AccessToken instance.
    access_token = prepare_access_token(@oauth_token, @oauth_token_secret)
    # use the access token as an agent to get the home timeline
    response = access_token.request(:get,
      "https://api.twitter.com/1.1/favorites/list.json?count=200&screen_name=#{screen_name}")

    JSON.parse(response.body).each do |favTweet|
      created = Date.strptime(favTweet["created_at"], "%a %b %d %H:%M:%S %Z %Y")
      if created.month == @mon && created.year == @year
        @favs << [favTweet["user"]["screen_name"], favTweet["id"]]
      end
    end
  end
end
