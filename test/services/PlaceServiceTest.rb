require 'test_helper'
require 'place_service'

class PlaceServiceTest < ActiveSupport::TestCase
    test "the truth" do
        assert true
    end

    id1 = "ohGSnJtMIC5nPfYRi_HTAg"
    id2 = "GXvPAor1ifNfpF0U5PTG0w"

    openingHourJSON = {
        "Days" => [
            "monday",
            "tuesday",
            "wednesday"
        ],

        "Hours" => [
            "0 - 12",
            "13 - 24"
        ]

    }

    placeJSON = {
        "Name" => "Test Name",
        "Location" => "Test Location",
        "OpeningHours" => [
            openingHourJSON,
            openingHourJSON,
            openingHourJSON
        ]
    }

   

    test "Successfull Queries" do
        place1 = PlaceService.query(id1) 
        place2 = PlaceService.query(id2)
        
        assert_not_nil(place1)
        assert_not_nil(place2)
    end

    test "Notfound Queries" do
        id ="1234"
        place = PlaceService.query(id)     
        assert_nil(place)
    end

    test "parse opening hour JSON" do
        openingHour = PlaceService.parseOpeningHourJSON(openingHourJSON)
        assert_not_nil(openingHourJSON)
        assert_equal(openingHourJSON["Days"].length, openingHour.days.length)
        assert_equal(openingHourJSON["Hours"].length, openingHour.hours.length)
    end

    test "parse place JSON" do
        place = PlaceService.parsePlaceJSON(placeJSON)
        assert_not_nil(openingHourJSON)
        assert_equal(placeJSON["OpeningHours"].length, place.opening_hours.length)
        assert_equal(placeJSON["Name"] , place.name)
        assert_equal(placeJSON["Location"], place.location)
    end


end