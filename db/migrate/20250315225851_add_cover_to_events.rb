class AddCoverToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :cover, :integer, null: false, default: 0
  end
end
