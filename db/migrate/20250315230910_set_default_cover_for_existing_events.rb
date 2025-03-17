class SetDefaultCoverForExistingEvents < ActiveRecord::Migration[8.0]
  def up
    # Set all existing events to 'free' (0)
    Event.where(cover: nil).update_all(cover: 0)
  end

  def down
    # No need to revert as we don't want to set covers back to nil
  end
end
