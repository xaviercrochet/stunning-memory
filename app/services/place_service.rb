require 'json'
require 'open-uri'

module PlaceService
    class Place
        attr_accessor :name, :location, :opening_hours

        def initialize
            @opening_hours = []
        end
    end

    class OpeningHour
        attr_accessor :days, :hours

        def initialize
            @days = []
            @hours = []
        end

        def getDaysHeading
            if @days.length == 0 
                return ''
            elsif @days.length == 1
                return @days[0]
            else
                return @days[0] + " - " + @days[@days.length - 1]
            end
        end

        def isToday?
            today = Date.today.strftime("%A")
            if not @days.index(today.downcase).nil?
                return true
            else
                return false
            end
        end


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
            place = PlaceService::Place.new
            place.name = result["Name"]
            place.location = result["Location"]
            result["OpeningHours"].each do | openingHourJSON |
                openingHour = PlaceService::OpeningHour.new
                openingHourJSON["Days"].each do | dayJSON|
                    openingHour.days << dayJSON
                end

                openingHourJSON["Hours"].each do | hourJSON|
                    openingHour.hours << hourJSON
                end
                place.opening_hours << openingHour

            end
            puts place
            
            return place
        end
    end
end