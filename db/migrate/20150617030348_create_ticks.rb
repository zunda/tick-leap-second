class CreateTicks < ActiveRecord::Migration
  def change
    create_table :ticks do |t|
      t.integer :number
      t.datetime :client_time
      t.datetime :server_time

      t.timestamps null: false
    end
  end
end
