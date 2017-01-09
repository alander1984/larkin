class AddStatusToLoad < ActiveRecord::Migration
 	def up
  	  change_table :loads do |t|
      	t.string :status
      end	
    end	

    def down
      remove_column :loads, :status
    end  
end
