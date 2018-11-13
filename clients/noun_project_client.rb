require 'open-uri'
require "noun-project-api"

class NounProjectClient

  def initialize
    @client = NounProjectApi::IconsRetriever.new(ENV['NOUN_PROJECT_KEY'], ENV['NOUN_PROJECT_SECRET'])
  end

  def find_icon(term)
    icon = @client.find(term).detect{|i|i.svg_url}
    open("./icons/#{term}.svg", 'wb') do |file|
      file << open(icon.svg_url).read
    end
  end

end
