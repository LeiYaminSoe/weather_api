module Openweather
  class Search
    def self.by_location(id)
      Faraday.get ENV["OPEN_WEATHER_URI"] + 'forecast?id=' + id + '&appid=' + ENV["OPEN_WEATHER_APP_ID"] + '&units=metric'
    end
    def self.by_summary(ids, unit)
      Faraday.get ENV["OPEN_WEATHER_URI"] + 'group?id='+ ids + '&appid=' + ENV["OPEN_WEATHER_APP_ID"] + '&units=' + unit
    end
  end
end
