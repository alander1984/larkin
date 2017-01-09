class Role < ActiveRecord::Base
	has_and_belongs_to_many :workers, :join_table => "workers_roles", :class_name => "Worker"
end