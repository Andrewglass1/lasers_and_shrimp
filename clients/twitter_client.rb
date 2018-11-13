require 'twitter'

class TwitterClient

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_KEY"]
      config.consumer_secret     = ENV["TWITTER_SECRET"]
    end
  end

  def find_tweets(term)
    @client.search(term)
  end

end
