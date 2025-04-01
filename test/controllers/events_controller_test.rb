require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @event = events(:one)
    @user = users(:one)
    @user.admin = true
    @user.save!
    sign_in @user
  end

  test "should get index" do
    get events_url
    assert_response :success
  end

  test "should get new" do
    get new_event_url
    assert_response :success
  end

  test "should create event" do
    assert_difference("Event.count") do
      post events_url, params: { event: {
        date: @event.date,
        location_id: @event.location_id,
        title: "Test Event",
        creator_id: @user.id,
        details: "Test details",
        start_time: @event.start_time,
        end_time: @event.end_time,
        cover: "free"
      } }
    end

    assert_redirected_to events_url
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_url(@event)
    assert_response :success
  end

  test "should update event" do
    patch event_url(@event), params: { event: {
      date: @event.date,
      location_id: @event.location_id,
      title: "Updated Event",
      creator_id: @user.id,
      details: "Updated details",
      start_time: @event.start_time,
      end_time: @event.end_time,
      cover: "free"
    } }
    assert_redirected_to events_url
  end

  test "should destroy event" do
    assert_difference("Event.count", -1) do
      @event.attendees.destroy_all
      delete event_url(@event)
    end

    assert_redirected_to events_url
  end
end
