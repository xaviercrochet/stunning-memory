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

        def isClosed?
            if @hours.length == 0
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
            begin
                json = JSON.parse(response.to_str)
                place = parsePlaceJSON(json) 
            rescue => error
                puts "cannot parse response JSON: " + error.to_s
            end          
        end
    end

    def self.parsePlaceJSON(placeJSON)
        place = PlaceService::Place.new
        place.name = placeJSON["Name"]
        place.location = placeJSON["Location"]
        openingHours = placeJSON["OpeningHours"]
        
        if not openingHours.nil?
            openingHours.each do | openingHourJSON |
                openingHour = parseOpeningHourJSON(openingHourJSON)
                if not openingHour.nil? then
                    place.opening_hours << openingHour
                end
            end
        end
        return place
    end

    def self.parseOpeningHourJSON(openingHourJSON)
        openingHour = PlaceService::OpeningHour.new
        days = openingHourJSON["Days"]
        hours = openingHourJSON["Hours"]
       
        if not hours.nil?
            openingHourJSON["Hours"].each do | hourJSON|
                openingHour.hours << hourJSON
            end
        end

        if not days.nil?
            openingHourJSON["Days"].each do | dayJSON|
                openingHour.days << dayJSON
            end
        end
        return openingHour
    end
end