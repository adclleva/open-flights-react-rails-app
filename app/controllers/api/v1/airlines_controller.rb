# we'll name space these inside a module
module Api
  module V1
    class AirlinesController < ApplicationController
      protect_from_forgery with: :null_session

      def index
        airlines = Airline.all

        render json: AirlineSerializer.new(airlines, options).serialized_json
      end

      def show
        airline = Airline.find_by(slug: params[:slug])

        render json: AirlineSerializer.new(airline, options).serialized_json
      end

      def create
        airline = Airline.new(airline_params)

        if airline.save
          render json: AirlineSerializer.new(airline).serialized_json
        else
          render json: { error: airlines.errors.messages }, status: 442
        end
      end

      def update
        airline = Airline.find_by(slug: params[:slug])

        if airline.update(airline_params)
          render json: AirlineSerializer.new(airline, options).serialized_json
        else
          render json: { error: airlines.errors.messages }, status: 442
        end
      end


      def destroy
        airline = Airline.find_by(slug: params[:slug])

        if airline.destroy
          head :no_content
        else
          render json: { error: airlines.errors.messages }, status: 442
        end
      end


      private

      # Strong params
      def airline_params
        params.require(:airline).permit(:name, :image_url)
      end

      # Used For compound documents with fast_jsonapi
      def options
        @options ||= { include: %i[reviews] }
      end
    end
  end
end