class CreatePipelines < ActiveRecord::Migration
  def change
    create_table :pipelines do |t|

      t.timestamps
    end
  end
end
