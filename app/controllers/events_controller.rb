class EventsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :set_locations, only: %i[ new edit create update ]
  before_action :ensure_manager, only: %i[ new create edit update destroy ]

  # GET /events or /events.json
  def index
    @events = Event.all
    @events = if params[:past_events] == "past"
      @events.past.order(date: :desc, start_time: :desc)
    else
      @events.upcoming.order(date: :asc, start_time: :asc)
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /events/1 or /events/1.json
  def show
    if params[:reset_others]
      @other_events = Event.where.not(id: @event.id).upcoming
    else
      @other_events = [] # Initialize as empty array when not resetting others
    end

    respond_to do |format|
      format.html
      format.turbo_stream
      format.json { render :show }
    end
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to events_path, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to events_path, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to events_path, status: :see_other, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Set available locations for the form
    def set_locations
      if current_user.admin?
        @locations = Location.all
      else
        # If user is a manager, show their managed locations
        @locations = current_user.managed_locations

        # If user doesn't manage any locations, show all locations
        if @locations.empty?
          @locations = Location.all
        end
      end
    end

    # Ensure the user is a manager of at least one location
    def ensure_manager
      unless current_user.manager? || current_user.admin?
        redirect_to events_path, alert: "You need to be a manager of at least one location or an admin to create or edit events."
      end
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:date, :location_id, :title, :creator_id, :details, :start_time, :end_time, :poster, :cover)
    end
end
