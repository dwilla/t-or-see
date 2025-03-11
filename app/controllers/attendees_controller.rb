class AttendeesController < ApplicationController
  def create
    @event = Event.find(params[:event_id])
    # This creates the join record in the attendees table
    @event.attendees.create(user: current_user)

    redirect_to @event, notice: "You are now attending this event!"
  end

  def destroy
    @attendee = Attendee.find(params[:id])
    @event = @attendee.event
    @attendee.destroy

    redirect_to @event, notice: "You are no longer attending this event."
  end
end
