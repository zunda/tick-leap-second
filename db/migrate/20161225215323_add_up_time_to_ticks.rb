class AddUpTimeToTicks < ActiveRecord::Migration
  def change
    add_column :ticks, :uptime, :float
  end
end
