# frozen_string_literal: true

# SubstringCalculation controllet
class SubstringCalculationsController < ApplicationController
  before_action :load_user
  before_action :authenticate_user!

  def index
    @user.substring_calculations
  end

  def create
    substr_cal = @user.substring_calculations.build(substring_calculation_params)
    if substr_cal.save
      render json: substr_cal, status: :created
    else
      render json: { errors: substr_cal.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    substr_cal = @user.substring_calculations.find(params[:id])

    if substr_cal.destroy
      render json: substr_cal, status: :ok
    else
      render json: substr_cal.errors.full_messages,
             status: :unprocessable_entity
    end
  end

  private

  def load_user
    @user = User.find_by(id: params[:user_id])
  end

  def substring_calculation_params
    params.require(:substring_calculations).permit(:main_string, :sub_string)
  end
end
