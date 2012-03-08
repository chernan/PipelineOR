class CreatePfiles < ActiveRecord::Migration
  def change
    create_table :pfiles do |t|

      t.timestamps
    end
  end
end
