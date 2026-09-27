# frozen_string_literal: true

module V1
  class EquipmentsController < V1::ApiController
    PAGE_SIZE = 3

    rescue_from Equipment::InvalidCategoryError, with: ->(e) { render json: { error: e.message }, status: :unprocessable_entity }
    rescue_from Equipment::InvalidPageError, with: ->(e) { render json: { error: e.message }, status: :unprocessable_entity }

    def index
      @equipments = Equipment.all
      @equipments = filter_by_category(@equipments)
      @equipments = filter_by_search(@equipments)
      @equipments = sort_equipments(@equipments)
      @equipments = paginate(@equipments)

      render json: @equipments
    end

    def show
      render json: Equipment.find(params[:id])
    end

    private

    def filter_by_category(scope)
      return scope if params[:category].blank?
      unless Equipment.categories.key?(params[:category])
        raise Equipment::InvalidCategoryError,
              'This category does not exist'
      end

      scope.where(category: params[:category])
    end

    def filter_by_search(scope)
      return scope if params[:search].blank?

      scope.search_by_name(params[:search])
    end

    def sort_equipments(scope)
      return scope if params[:sort].blank?

      params[:sort] == 'desc' ? scope.order(name: :desc) : scope.order(name: :asc)
    end

    def paginate(scope)
      return scope if params[:page].blank?

      page = params[:page].to_i
      raise Equipment::InvalidPageError, 'Page must be positive' if page <= 0

      scope.limit(PAGE_SIZE).offset((page - 1) * PAGE_SIZE)
    end
  end
end
