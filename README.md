# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version => ruby 2.6.5p114
                  rails (6.0.3.4)

* Third Party API => Open Weather Map

* How to run Server => rails s

* Database => No Database as it acts as integration API.

* How to run the test for Daily API request Limit => curl -I -s "http://localhost:3000/api/v1/weather/location/1850144[1-10035]" | grep HTTP/

curl -I -s "http://localhost:3000/api/v1/weather/summary?unit=18C&locations=2210247,2563191,232323[1-10035]" | grep HTTP/

* Request rate limit throttling => Rack::Attack

