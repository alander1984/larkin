class LoadsController < ApplicationController
before_action :set_load, only: [:show, :edit, :update, :destroy, :loadUp, :loadDown]

	def new
		@load = Load.new;
		@timeshifts = Timeshift.all;
		@trucks = Truck.all;
		@drivers = Worker.joins(:roles).where("roles.code = 'driver'").all;
		respond_to do |format|
			format.js
		end	
	end	

	def show
		@loadOrders=Order.where('load_id=:load_id',{load_id: params['id']}).order(:sort);
		respond_to do |format|
			format.xls
			format.html { redirect_to url_for(:action => :index, :loadid => params['id'])}
		end	
	end	

	def destroy
		@load.orders.delete_all;
		@load.destroy;
		respond_to do |format|
			format.html { redirect_to loads_path, notice: 'Load have been deleted successfully...' }
		end	
	end	

	def create
		@activeLoads = Load.where('date>=current_date').all;
		@load = Load.new(load_params);
		@load.date = Date.strptime(load_params['date'],'%m/%d/%Y');
		@load.status=0;
		@load.save;
	end	

	def update
		@load.update(load_params);
		respond_to do |format|
			format.js
		end	
	end	

	def index
		if current_worker.roles.find_by(code: "disp")!=nil
			@loads = Load.where('date>=current_date').all; #Сюда добавить сортировку
		else
			#Ну не диспетчеру не надо видеть невалидные погрузки	
			@loads = Load.where('date>=current_date and worker_id=:worker_id',{worker_id: current_worker.id}).all;
			@loads = @loads.all.reject {|load| !load.validRest} 
		end	
		@timeshifts = Timeshift.all;
		@trucks = Truck.all;
		@drivers = Worker.joins(:roles).where("roles.code = 'driver'").all;
		@timeshifts = Timeshift.all;
		if params['loadid'].nil?
			@loadOrders=nil;
		else
			@loadOrders=Order.where('load_id=:load_id',{load_id: params['loadid']}).order(:sort);
		end	
	end	

	def showLoadContent
		@loadOrders=Order.where('load_id=:load_id',{load_id: params['id']}).order(:sort);
		@timeshifts = Timeshift.all;
		@trucks = Truck.all;
		@drivers = Worker.joins(:roles).where("roles.code = 'driver'").all;
		@timeshifts = Timeshift.all;
		respond_to do |format|
			format.js;
		end	
	end


	private

		def set_load
			@load = Load.find(params['id']);
		end		

		def load_params
      		params[:load].permit(:truck_id,:worker_id,:timeshift_id,:date,:status)
    	end

end
