class V1::EquipmentsController < ApplicationController
  LIMIT = 3

  def index
    @equipments = Equipment.all

    if params.dig(:category).present?
      if Equipment.categories.keys.include?(params[:category])
        @equipments = Equipment.where(category: params[:category].to_i)
      else
        render json: { error: "This category does not exist" }, status: :unprocessable_entity and return
      end
    end

    if params.dig(:page).present?
      page = params[:page].to_i
      if page <= 0
        render json: { error: "Page must be positive" }, status: :unprocessable_entity and return
      else
        @equipments.limit(LIMIT).offset((page - 1) * LIMIT)
      end
    end

    if params.dig(:sort).present?
      sort = params[:sort]
      @equipments = if sort.eql?("desc")
        @equipments.order("name desc")
      else
        @equipments.order("name asc")
      end
    end

    render json: @equipments
  end

  def show
    @equipment = Equipment.find(params[:id])

    render json: @equipment
  end
end
