class SearchController < ApplicationController
    def list
        @results = SearchService.search()
    end
end
