class DispController < ApplicationController

	def start
		@activeLoads = Load.where('date>=current_date').all;
		@readyOrders = Order.joins(:load).where('loads.date>=current_Date').count;
	end	

end
