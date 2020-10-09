module SearchService
    class Result
        attr_accessor :title,:id, :description
    end

    def self.search()
        result1 = SearchService::Result.new
        result1.title = "Cool restaurant 1"
        result1.description = "Vivamus volutpat elit sit amet ex feugiat pharetra. Curabitur sed velit et enim ultrices euismod vel eu leo."
        result1.id = "ohGSnJtMIC5nPfYRi_HTAg"

        result2 = SearchService::Result.new
        result2.title = "Very nice snack 2 "
        result2.description = "Cras nec dui vel justo cursus finibus et hendrerit erat. Pellentesque lobortis sagittis erat"
        result2.id = "GXvPAor1ifNfpF0U5PTG0w"
        return [result1, result2]

    end
end
