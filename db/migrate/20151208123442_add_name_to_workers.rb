class AddNameToWorkers < ActiveRecord::Migration
  def up
  	change_table :workers do |t|
      t.string :name
    end
    Worker.update_all ["name = email"]
  end

  def down
  	remove_column :workers, :name
  end
  	
end
