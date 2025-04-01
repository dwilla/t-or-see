require "test_helper"

class LocationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @location = locations(:one)
    @user = users(:one)
    @user.admin = true
    @user.save!
    sign_in @user
  end

  test "should get index" do
    get locations_url
    assert_response :success
  end

  test "should get new" do
    get new_location_url
    assert_response :success
  end

  test "should create location" do
    assert_difference("Location.count") do
      post locations_url, params: { location: {
        name: "New Location",
        address: "123 Test St",
        description: "A test location",
        city: "Test City",
        state: "TS",
        zip_code: "12345",
        category: "food_and_beverage"
      } }
    end

    assert_redirected_to location_url(Location.last)
  end

  test "should show location" do
    get location_url(@location)
    assert_response :success
  end

  test "should get edit" do
    get edit_location_url(@location)
    assert_response :success
  end

  test "should update location" do
    patch location_url(@location), params: { location: {
      name: "Updated Location",
      address: "456 Test Ave",
      description: "An updated test location",
      city: "Updated City",
      state: "TS",
      zip_code: "54321",
      category: "food_and_beverage"
    } }
    assert_redirected_to location_url(@location)
  end

  test "should destroy location" do
    # First, ensure there are no associated records
    Attendee.where(event_id: Event.where(location: @location).pluck(:id)).delete_all

    assert_difference("Location.count", -1) do
      delete location_url(@location)
    end

    assert_redirected_to locations_url
  end
end
