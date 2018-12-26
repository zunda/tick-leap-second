class RemoveServerTimeFromTicks < ActiveRecord::Migration[4.2]
  def change
    remove_column :ticks, :server_time, :datetime
  end
end
