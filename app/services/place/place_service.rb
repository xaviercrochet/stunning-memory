require 'json'
require 'open-uri'

module PlaceService
    class Place
        attr_accessor :name, :location, :opening_hours
    end

    def self.query(id)
        endpoint = ENV['LOCALSEARCH_API_URL']
        begin
            response = RestClient::Request.new(
                :method => :get,
                :url => endpoint + '/place/' + id,
                :verify_ssl => false
            ).execute
        rescue RestClient::ExceptionWithResponse => e
            e.response
        end
        if not response.blank?
            result = JSON.parse(response.to_str)
            puts "service: " +  result.to_s
            place = PlaceService::Place.new
            place.name = result["Name"]
            place.location = result["Location"]
            place.opening_hours = result["OpeningHours"]
            return place
        end
    end
end