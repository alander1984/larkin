class Address < ActiveRecord::Base
	has_many   :origin;
	belongs_to :city;
	has_many  :orders;

	def to_s
		s = zip+' '+rawline;
		if city!=nil
			s = city.name+' '+s;
			if city.state!=nil
				s= city.state.name+' '+s;
				if city.state.country!=nil
					s= city.state.country.name+' '+s;
				end	
			end	
		end	
		return s;
	end	
end	