class StationsController < ApplicationController
  def index
    @stations = Station.where(contract_id: params[:contract_id])

    render json: @stations, each_serializer: StationReducedSerializer
  end

  def show
    @station = Station.find(params[:id])

    render json: @station
  end
end
