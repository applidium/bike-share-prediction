class ContractsController < ApplicationController
  def index
    @contracts = Contract.all

    render json: @contracts
  end
end
