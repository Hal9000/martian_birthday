class Api::V1::MartianDateController < ApplicationController
  def show
    earth_birthday = Date.parse(params[:id])
    martian_birthday = MarsDateTime.new(earth_birthday)
    render json: {
      status: true,
      result: {
        earth_date: params[:id],
        martian_date: martian_birthday
      }
    }
  end
end
