class AddTimeAndImageToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :start_time, :time
    add_column :events, :end_time, :time
    add_column :events, :image, :string
  end
end
