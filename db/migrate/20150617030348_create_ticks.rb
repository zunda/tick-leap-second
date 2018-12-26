class CreateTicks < ActiveRecord::Migration[4.2]
  def change
    create_table :ticks do |t|
      t.integer :number
      t.datetime :client_time
      t.datetime :server_time

      t.timestamps null: false
    end
  end
end
