class AddUpTimeToTicks < ActiveRecord::Migration[4.2]
  def change
    add_column :ticks, :uptime, :float
  end
end
