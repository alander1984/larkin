class SearchController < ApplicationController

	def findPurchase
		orders = Order.find_by(number: params['number']);
		if orders.nil?
			respond_to do |format|
				format.html {}
			end	
		else
			respond_to do |format|
				format.html {redirect_to order_path(orders.id), notice: 'Order found' }
			end	
		end	
	end	
end
