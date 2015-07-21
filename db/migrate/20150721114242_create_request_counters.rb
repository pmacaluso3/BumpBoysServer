class CreateRequestCounters < ActiveRecord::Migration
  def change
    create_table :request_counters do |t|
      t.integer :counter, default: 0
    end
  end
end
