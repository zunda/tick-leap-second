class AddSourceToTicks < ActiveRecord::Migration
  def change
    add_column :ticks, :source, :string
  end
end
