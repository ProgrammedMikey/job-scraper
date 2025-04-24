class Api::JobsController < ApplicationController
    def index
        jobs = IndeedScraper.call
        render json: jobs
    end
end
