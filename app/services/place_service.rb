require 'json'
require 'open-uri'

module PlaceService
    class Place
        attr_accessor :name, :location, :opening_hours
    end

    def self.query(id)
        endpoint = ENV['LOCALSEARCH_API_URL']
        if endpoint.nil?
            puts "Eenvironment variable LOCALSEARCH_API is not defined"
            return nil
        end

        begin
            response = RestClient::Request.new(
                :method => :get,
                :url => endpoint + '/place/' + id,
                :verify_ssl => false
            ).execute
        rescue RestClient::ExceptionWithResponse => e
            puts e.to_s
            e.response
        rescue Errno::ECONNREFUSED => e
            puts "local search api not available: " + e.to_s
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