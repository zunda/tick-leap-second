class RemoveClientTimeFromTicks < ActiveRecord::Migration
  def change
    remove_column :ticks, :client_time, :datetime
  end
end
