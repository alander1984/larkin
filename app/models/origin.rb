class Origin < ActiveRecord::Base
	belongs_to :address;
	has_many :orders;
end	