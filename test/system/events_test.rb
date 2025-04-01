require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @event = events(:one)
    @user = users(:one)  # This user is already a manager in the fixtures
    sign_in @user
  end

  test "visiting the index" do
    visit events_url
    assert_selector "h1", text: "Events"
  end
end
