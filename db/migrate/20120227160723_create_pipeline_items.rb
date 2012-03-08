class CreatePipelineItems < ActiveRecord::Migration
  def change
    create_table :pipeline_items do |t|

      t.timestamps
    end
  end
end
