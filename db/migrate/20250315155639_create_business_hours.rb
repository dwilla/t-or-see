class CreateBusinessHours < ActiveRecord::Migration[8.0]
  def change
    create_table :business_hours do |t|
      t.integer :day
      t.time :opens
      t.time :closes
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
