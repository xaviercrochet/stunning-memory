require_relative "../services/search/search_service"

class SearchController < ApplicationController
    def list
        @results = SearchService.search()
    end
end
