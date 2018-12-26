class AddGroupToTicks < ActiveRecord::Migration[4.2]
  def change
    add_column :ticks, :group, :integer
  end
end
