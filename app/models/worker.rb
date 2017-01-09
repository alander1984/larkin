class Worker < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_and_belongs_to_many :roles , :join_table => "workers_roles", :class_name => "Role" 
  has_and_belongs_to_many :trucks, :join_table => "loads", :class_name => "Truck"  
end
