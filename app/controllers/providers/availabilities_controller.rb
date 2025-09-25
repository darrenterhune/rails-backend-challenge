module Providers
  class AvailabilitiesController < ApplicationController
    # GET /providers/:provider_id/availabilities
    # Expected params: from, to (ISO8601 timestamps)
    def index
      @availabilities = Availability.where(provider_id: params[:provider_id]).between_dates(params[:from], params[:to])

      render(json: @availabilities)
    end
  end
end
