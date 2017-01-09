class Truck < ActiveRecord::Base
	has_and_belongs_to_many :workers, :join_table => "loads", :class_name => "Worker"
	belongs_to :Load
end	