require 'json'
require 'open-uri'


module PlaceService
    class Place
        attr_accessor :name, :location, :schedules, :open_next

        def initialize
            @schedules = []
        end

        def has_open_next?
           ! @open_next.nil?
        end

        def mergeSchedule(schedules_to)
            schedules_to.each do | schedule |
                if @schedules.length == 0 then
                    @schedules << schedule
                else
                    last = @schedules.length - 1
                    if @schedules[last].compare(schedule) then
                        @schedules[last].days << schedule.days[0]
                    else
                        @schedules << schedule
                    end
                end
            end
        end
    end

    class HoursRange
        attr_accessor :start, :end, :is_open_now
        
        def getRange
            return @start + " - " + @end
        end

        def compare(hour_range_to)
            @start == hour_range_to.start && @end == hour_range_to.end
        end

    end

    class Schedule
        attr_accessor :days, :hours_ranges

        def initialize
            @days = []
            @hours_ranges = []
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

        def compare(schedule)
            if @hours_ranges.length != schedule.hours_ranges then
                return false
            end

            @hours_ranges.each do | hour_range|
                schedule.hour_ranges.each do | hour_range_to |
                    puts hour_range_to.start + " :  " + hour_range.start
                    if ! hour_range.compare(hour_range_to) then
                        return false
                    end
                end
            end
            return true
        end

        def isToday?
            today = Date.today.strftime("%A")
            @days.index(today)
        end

        def isClosed?
           @hours_ranges.length == 0
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
        if ! response.blank?
            json = JSON.parse(response.to_str)
            place = parsePlaceJSON(json)
            begin
            rescue => error
                puts "cannot parse response JSON: " + error.to_s
            end
            return place          
        end
    end

    def self.parsePlaceJSON(json)
        place = PlaceService::Place.new
        
        place.name = json["Name"]
        place.location = json["Location"]
        
        schedules = []
        json["Schedules"].each do |schedule_json|
            schedule = parseScheduleJSON(schedule_json)
            schedules << schedule
        end
        
        place.mergeSchedule(schedules)
        place.open_next = parseScheduleJSON(json["OpenNext"])
        return place
    end

    def self.parseScheduleJSON(schedule_json)
        schedule = PlaceService::Schedule.new
        
        schedule_json["HoursRanges"].each do |hour_range_json|
            hours_range = PlaceService::HoursRange.new
            hours_range.start = hour_range_json["Start"]
            hours_range.end = hour_range_json["End"]
            hours_range.is_open_now = hour_range_json["IsOpenNow"]
            schedule.hours_ranges << hours_range
        end

        schedule_json["Days"].each do |day_json|
            schedule.days << day_json
        end
        
        return schedule
    end
end