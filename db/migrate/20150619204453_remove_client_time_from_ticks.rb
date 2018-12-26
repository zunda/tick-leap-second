class RemoveClientTimeFromTicks < ActiveRecord::Migration[4.2]
  def change
    remove_column :ticks, :client_time, :datetime
  end
end
