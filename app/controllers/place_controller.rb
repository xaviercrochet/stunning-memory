class PlaceController < ApplicationController
    def show
        @id = params[:id]
        if @id.blank?
            render file: "#{Rails.root}/public/404", layout: true, status: :not_found
        else
            @place = PlaceService.query(@id)
            if @place.nil?
                render file: "#{Rails.root}/public/404", layout: true, status: :not_found
            end

        end
    end
end

def place_params
    params.require(:id)
end
