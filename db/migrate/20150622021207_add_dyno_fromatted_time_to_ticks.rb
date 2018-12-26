class AddDynoFromattedTimeToTicks < ActiveRecord::Migration[4.2]
  def change
    add_column :ticks, :dyno_time, :datetime
    add_column :ticks, :dyno_time_float, :float
    add_column :ticks, :dyno_time_str, :string
  end
end
