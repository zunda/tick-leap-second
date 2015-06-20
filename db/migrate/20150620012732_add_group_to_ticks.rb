class AddGroupToTicks < ActiveRecord::Migration
  def change
    add_column :ticks, :group, :integer
  end
end
