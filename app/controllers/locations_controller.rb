class LocationsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show business_hours ]
  before_action :set_location, only: %i[ show edit update destroy business_hours ]
  before_action :ensure_admin, except: %i[ index show edit update business_hours ]
  before_action :ensure_admin_or_manager, only: %i[ edit update ]

  def index
    @locations = Location.all
    @locations = @locations.where(category: params[:category]) if params[:category].present?
    @locations = @locations.select(&:currently_open?) if params[:open_now] == "true"
    @categories = Location.categories.keys.map { |k| [ k.titleize.gsub("_", "/"), k ] }

    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update("locations", partial: "locations/list") }
    end
  end

  def show
    @expanded = params[:expanded] == "true"

    respond_to do |format|
      format.html
      format.json { render json: @location }

      if turbo_frame_request?
        format.html { render partial: "business_hours", locals: { location: @location, expanded: @expanded } }
      end
    end
  end

  def new
    @location = Location.new
  end

  def edit
  end

  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: "Location was successfully created." }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: "Location was successfully updated." }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @location.destroy!

    respond_to do |format|
      format.html { redirect_to locations_path, notice: "Location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def business_hours
    @expanded = params[:expanded] == "true"
    render partial: "business_hours", locals: { location: @location, expanded: @expanded }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.require(:location).permit(
        :name, :address, :city, :state, :zip_code, :image, :category,
        :tagline, :description,
        business_hours_attributes: [ :id, :day, :opens, :closes, :_destroy ]
      )
    end

    # Ensure the user is an admin
    def ensure_admin
      unless current_user&.admin?
        redirect_to root_path, alert: "You need to be an admin to access location management."
      end
    end

    # Ensure the user is either an admin or a manager of this location
    def ensure_admin_or_manager
      unless current_user&.admin? || current_user&.managed_locations&.include?(@location)
        redirect_to root_path, alert: "You need to be an admin or a manager of this location to edit it."
      end
    end
end
