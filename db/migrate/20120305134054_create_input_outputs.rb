class CreateInputOutputs < ActiveRecord::Migration
  def change
    create_table :input_outputs do |t|

      t.timestamps
    end
  end
end
