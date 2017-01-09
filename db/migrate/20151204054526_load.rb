class Load < ActiveRecord::Migration
  def up
  	create_table :trucks do |t|
  		t.string :no;
  		t.integer :volume;
  	end;	

  	create_table :timeshifts do |t|
  		t.string :code;
  		t.string :name;
  		t.integer :num;
  	end;	

  	create_table :loads do |t|
  		t.datetime :date;
  		t.belongs_to :worker, index: true;
  		t.belongs_to :truck, index: true;
  		t.belongs_to :timeshift, index: true;
  	end	

	add_foreign_key :loads, :workers;
	add_foreign_key :loads, :trucks;
	add_foreign_key :loads, :timeshifts;


  end
  def down
  	drop_table :loads;
  	drop_table :timeshifts;
  	drop_table :trucks;
  end	
end
