class Order < ActiveRecord::Base
  	belongs_to :client;
  	belongs_to :address;
  	belongs_to :origin;
  	belongs_to :timeshift;
  	belongs_to :load;
end	