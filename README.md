# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version => ruby 2.6.5p114
                  rails (6.0.3.4)

* Third Party API => Open Weather Map

* How to run Server => rails s

* Database => No Database as it acts as integration API.

* Request rate limit throttling => Rack::Attack

* How to run the test for Daily API request Limit => curl -I -s "http://localhost:3000/api/v1/weather/location/1850144[1-10035]" | grep HTTP/

  curl -I -s "http://localhost:3000/api/v1/weather/summary?unit=18C&locations=2210247,2563191,232323[1-10035]" | grep HTTP/
  
  * To run 10000 request, it took 1 hour and 3 minutes for me. So in order to make the test easier, do this instead.
    In config/initializers/rack_attack.rb file,
    1. Remove #(comment out) from throttle('req/ip', :limit => 7, :period => 24.hours) do |req|
    2. Add #(comment out) to throttle('req/ip', :limit => 10000, :period => 24.hours) do |req|
    3. Run curl -I -s "http://localhost:3000/api/v1/weather/summary?unit=18C&locations=2210247,2563191,232323[1-10]" | grep HTTP/
    4. OR 
    5. curl -I -s "http://localhost:3000/api/v1/weather/location/1850144[1-10]" | grep HTTP/
    
  * Limit and period can be updated freely for testing, for example, :limit => 5, :period => 5.seconds
  * Change curl cmd according to limit, for example, [1-15] or [1-35]

* No Authentication yet

