class AddSortingToOrders < ActiveRecord::Migration
  def up
  	  change_table :orders do |t|
      	t.integer :sort
      end	
  end

  def down
  	remove_column :orders, :sort
  end
end
