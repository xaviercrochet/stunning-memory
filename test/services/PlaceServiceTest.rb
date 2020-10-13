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
end