class RemoveServerTimeFromTicks < ActiveRecord::Migration
  def change
    remove_column :ticks, :server_time, :datetime
  end
end
