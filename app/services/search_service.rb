module SearchService
    class Result
        attr_accessor :title,:id
    end

    def self.search()
        result1 = SearchService::Result.new
        result1.title = "Cool restaurant 1"
        result1.id = "ohGSnJtMIC5nPfYRi_HTAg"

        result2 = SearchService::Result.new
        result2.title = "Very nice snack 2 "
        result2.id = "GXvPAor1ifNfpF0U5PTG0w"
        return [result1, result2]

    end
end
