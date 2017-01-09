class AddRole < ActiveRecord::Migration
  
  def up
  	create_table :roles  do |t|
  		t.string :code;
  		t.string :name;
  	end;	
	create_table :workers_roles, id: false do |t|
		t.belongs_to :role, index: true;
		t.belongs_to :worker, index: true;
	end  	
	add_foreign_key :workers_roles, :workers;
	add_foreign_key :workers_roles, :roles;
  end

  def down
  	drop_table :roles;
  	drop_table :workers_roles
  end	


end
