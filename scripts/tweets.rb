require "./models/item"

tweets = TwitterClient.new.find_tweets('#rubyconf')

tweets.each do |tweet|
  Item.new(template: :phone_case,
           tweet: tweet,
           file_name: "tweet_#{tweet.id}")
end
