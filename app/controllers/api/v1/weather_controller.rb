class Api::V1::WeatherController < ApplicationController

  #method to show a list of temperature for next 5 days
  #in one specific location(by location_id)
  #url: /weather/location/:id
  #for example: id => 1850144(for Tokyo)
  def location
    if params[:id]
      #call third party API(OpenWeatherMap) with location ID
      api_response = Openweather::Search.by_location(params[:id])
      if api_response.present?
        if api_response.body.present?
          api_response_body = JSON.parse(api_response.body)
          if api_response_body.present?
            #check if there is data coming from third party API
            if api_response_body["cod"].present? && api_response_body["cod"] != "200"
              render json: api_response_body and return
            else
              @response = get_response_by_location(api_response_body)
              render json: @response and return
            end
          end
        end
      end
    end
    render json: { status: 404, message: 'No Data Available' }
  end

  #method to show a list of user favorite locations
  #where the temperature is above certain temperature
  #temperature and unit(12C)
  #list of locations(location_ids)
  #url: /weather/summary?unit=12C&locations=2210247,2563191,232323
  def summary
    unit_num = 0;
    unit = "";
    if params[:unit]
      unit_num = params[:unit].scan(/\d+/)[0]
      #make matric as default(according to dk standard)
      if params[:unit].gsub(unit_num, "") == "C" || params[:unit].gsub(unit_num, "") == "c" || params[:unit].gsub(unit_num, "") == "°C" || params[:unit].gsub(unit_num, "") == "°c"
        unit = "metric"
      elsif params[:unit].gsub(unit_num, "") == "F" || params[:unit].gsub(unit_num, "") == "f" || params[:unit].gsub(unit_num, "") == "°F" || params[:unit].gsub(unit_num, "") == "°f"
        unit = "imperial"
      else
        unit = "metric"
      end
      unit_num = unit_num.to_i
    end
    if params[:locations]
      locations = params[:locations]
    end
    if locations.present? && unit.present?
      #call third party API(OpenWeatherMap) with Unit and location IDs
      api_response = Openweather::Search.by_summary(locations, unit)
      if api_response.present?
        if api_response.body.present?
          api_response_body = JSON.parse(api_response.body)
          #check if there is data coming from third party API
          if api_response_body.present?
            if api_response_body["cod"].present? && api_response_body["cod"] != "200"
              render json: api_response_body and return
            else
              @response = get_response_by_summary(api_response_body, unit_num)
              render json: @response and return
            end
          end
        end
      end
    end
    render json: { status: 404, message: 'No Data Available' }
  end

  #reform response json from third party API
  #to get required data only
  def get_response_by_location(response)
    #make Date-Month-Year as default(according to dk standard)
    today = Date.today.strftime('%d-%m-%Y')
    city_info_hash = Hash.new
    date_hash = Hash.new
    temp_arr = Array.new
    #get city information first
    response["city"].map do |city|
      if city[0] == "id" ||  city[0] == "name" ||  city[0] == "country"
        city_info_hash[city[0]] = city[1]
      end
    end
    #get 5 days forecast start from next day
    #so exclude today forecast
    response["list"].map do |list|
      dt_date = list["dt_txt"].to_date.strftime('%d-%m-%Y')
      if today != dt_date
         #make new array if date has changed
         unless date_hash.key?(dt_date)
           temp_arr = Array.new
         end
         temp_arr << list["main"]["temp"]
         #hash with key, value pair like {"8.2.2021" => [13.4, 12.3, 14.1, 13.2, 11.2]}
	       date_hash[list["dt_txt"].to_date.strftime('%d-%m-%Y')] = temp_arr
      end
    end
    #get average temperature of a day as third party API sent data for every 3 hours
    date_temp_hash = Hash[date_hash.map { |k,v| [k, (v.inject(:+) / v.size).round()] }]
    #merge city information and temperature for 5 days
    response_hash = city_info_hash.merge(date_temp_hash)
    return response_hash
  end

  #reform response json from third party API
  #to get required data only
  def get_response_by_summary(response, unit_num)
    city_info_arr = Array.new
    response["list"].map do |list|
      city_info_hash = Hash.new
      #check if temperature is above certain temperature
      if list["main"]["temp"] > unit_num
        city_info_hash["id"] = list["id"]
        city_info_hash["name"] = list["name"]
        city_info_hash["country"] = list["sys"]["country"]
        city_info_hash["temp"] = list["main"]["temp"].round()
      end
      city_info_arr << city_info_hash
    end
    return city_info_arr
  end
end
