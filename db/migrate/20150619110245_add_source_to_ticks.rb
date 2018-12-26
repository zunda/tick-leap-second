class AddSourceToTicks < ActiveRecord::Migration[4.2]
  def change
    add_column :ticks, :source, :string
  end
end
