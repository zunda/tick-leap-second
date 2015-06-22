class AddDynoFromattedTimeToTicks < ActiveRecord::Migration
  def change
    add_column :ticks, :dyno_time, :datetime
    add_column :ticks, :dyno_time_float, :float
    add_column :ticks, :dyno_time_str, :string
  end
end
