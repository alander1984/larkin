class Order < ActiveRecord::Migration
  def up
  	create_table :countries do |t|
  		t.string :name
  	end	
  	create_table :states do |t|
  		t.string :name;
  		t.belongs_to :country;
  	end	
  	create_table :cities do |t|
  		t.string :name;
  		t.belongs_to :state;
  	end	
  	create_table :addresses do |t|
  		t.belongs_to :city;
  		t.string :rawline;
  		t.string :zip
  	end	
  	create_table :origins do |t|
  		t.string :name;
  		t.belongs_to :address;
  	end	
  	create_table :clients do |t|
  		t.string :name;
  		t.string :phone;
  	end	
  	create_table :orders do |t|
  		t.string :number;
  		t.belongs_to :client;
  		t.belongs_to :address;
  		t.belongs_to :origin;
  		t.belongs_to :timeshift;
  		t.belongs_to :load;
  		t.datetime :prefdate;
  		t.float :volume;
  		t.integer :quantity;
  	end	
  	add_foreign_key :cities, :states;
  	add_foreign_key :states, :countries;
  	add_foreign_key :addresses, :cities;
  	add_foreign_key :origins, :addresses;
  	add_foreign_key :orders, :clients;
  	add_foreign_key :orders, :origins;
  	add_foreign_key :orders, :timeshifts;
  	add_foreign_key :orders, :loads;
    #где базируется головной офис компании мы знаем всегда, 
    #поэтому можем немного преднастроить систему
  	Country.create :name => 'US', :id => 1;
  	State.create :name => 'NC', :id => 1, :country_id => 1;
    City.create :name => 'RALEIGH', :id =>1, :state_id => 1;
    Address.create :id => 1, :city_id => 1, :rawline => '1505 S BLOUNT ST', :zip => '27603'
    Origin.create :id => 1, :name => 'Larkin LLC', :address_id => 1;
    Timeshift.create :id =>1, :code => 'M', :name => 'Morning 8am - 12 pm', :num => 1;
    Timeshift.create :id =>2, :code => 'N', :name => 'Afternoon 12pm - 6pm', :num => 2;
    Timeshift.create :id =>3, :code => 'E', :name => 'Evening 6pm - 10 pm', :num => 3;
    #приходится сбрасывать последовательность, ибо потом сохранятсья не будет, если принудительно выставлять id
    ActiveRecord::Base.connection.reset_pk_sequence!('countries');
    ActiveRecord::Base.connection.reset_pk_sequence!('states');
    ActiveRecord::Base.connection.reset_pk_sequence!('cities');
    ActiveRecord::Base.connection.reset_pk_sequence!('addresses');
    ActiveRecord::Base.connection.reset_pk_sequence!('origins');
    ActiveRecord::Base.connection.reset_pk_sequence!('timeshifts');
  end
  def down
  	drop_table :orders;
  	drop_table :clients;
  	drop_table :origins;
  	drop_table :addresses;
  	drop_table :cities;
  	drop_table :states;
  	drop_table :countries;
  end	
end
