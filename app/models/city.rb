class City < ActiveRecord::Base
	has_many  :addresses;
	belongs_to :state;

	def country
		if state!=nil
			return state.country
		else	
			return nil
		end	
	end	
	def country_id
		if country!=nil
			return country.id
		else
			return nil
		end		
	end	
end	