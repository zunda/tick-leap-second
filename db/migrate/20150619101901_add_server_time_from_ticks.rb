class AddServerTimeFromTicks < ActiveRecord::Migration[4.2]
  def change
    reversible do |dir|
      change_table :ticks do |t|
        dir.up {
          execute('ALTER TABLE "ticks" ADD COLUMN "server_time" timestamp DEFAULT CURRENT_TIMESTAMP')
        }
        dir.down {
          execute('ALTER TABLE "ticks" DROP COLUMN "server_time"')
        }
      end
    end
  end
end
