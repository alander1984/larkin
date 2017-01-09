class OrdersController < ApplicationController
before_action :set_order, only: [:show, :edit, :update, :destroy, :up, :down, :removeFromLoad, :selectLoad, :fixSelectedLoad]

	def new
		@order = Order.new;
		@countries = Country.all;
		@states = State.all;
		@origins = Origin.all;
		@timeshifts = Timeshift.all;
		@order.number = GetRandOrderNo();
		@order.client = Client.new;
		address = Address.new;
		address.city= City.new;
		address.city.state=State.new;
		address.city.state.country = Country.new;
		@order.address = address;
	end	

	def GetRandOrderNo
		e = true;
		while e #Проверяем что номер заказа будет уникальный
			#Для нормальной работы в продакшне метод должен быть синхронизированный
			s = rand(999999999).to_s;
			if s.length<9 
				s = '100000000'[0..8-s.length]+s;
			end	
			e = Order.find_by(number: s)!=nil;
		end	
		return s;
	end

	def updateOriginInfo
		if params['o_id']!= nil
			origin = Origin.find(params['o_id']);
			@originInfo=origin.name+'; '+
					origin.address.rawline+'; '+
					origin.address.zip+'; '+
					origin.address.city.name+'; '+
					origin.address.city.state.name+'; '+
					origin.address.city.state.country.name;
		else
			@originInfo = ''
		end				
		respond_to do |format|
			format.js
		end	
	end	


	def create
		@order = Order.new();
		#Будем раскладывать все по связанным сущностям
		saveOrder;
		respond_to do |format|
			format.html { redirect_to orders_path, notice: 'Order creation cancelled...' }
		end	
	end	

	def index
		@orders = Order.where('load_id is null').paginate(page: params[:page], per_page: 15)
		@loads = Load.where("date >= current_date").all;
		respond_to do |format|
  			format.html
  			format.js
		end
	end	

	def update
		saveOrder;
		if params['return_to']!=nil?
			logger.info('%%%%%%%%%%%%%%%% '+params['return_to']);
		end	
		respond_to do |format|
			format.html { redirect_to getBackURL, notice: 'Order have been updated successfully...' }
		end	
	end	

	def show
		@countries = Country.all;
		@states = State.all;
		@origins = Origin.all;
		@timeshifts = Timeshift.all;
	end	

	def autoDistribute
		@order = Order.find(params['id']);
		if @order!=nil
			loads = Load.joins(:timeshift).where('date>=current_date').all.order('((date::date-cast(current_Date as date)::date)+cast(num as float))/3');
			found = false;
			i=0; fload=nil;
			while (!found)&&(i<loads.size) do
				logger.info('size='+loads.size.to_s+' i='+i.to_s);
				logger.info(loads[0].to_s+'  '+@order.to_s);
				if (loads[i].avalVolume >= @order.volume)&&(loads[i].validRest)
					logger.info('aval='+loads[i].avalVolume.to_s+'; date='+loads[i].date.strftime('%m/%d/%Y'));
					if fload.nil? 
						fload = loads[i]; 
					end;
					logger.info('loads[i].date='+loads[i].date.strftime('%m/%d/%Y'));
					logger.info(fload);
					if (loads[i].date==@order.prefdate)#&&(fload.date!=@order.prefdate) 
						fload = loads[i]; 						
						if (loads[i].timeshift=@order.timeshift)#&&(fload.timeshift!=@order.timeeshift) 
							fload = loads[i];
							found=true;	
						end	
 					end	
				end
				i += 1;
			end	
			if !fload.nil?
				logger.info('floadid = '+fload.timeshift.name+' dloaddate='+fload.date.to_s);
				@order.sort = Order.where('load_id=:load_id',{load_id: fload.id}).maximum(:sort);
				if @order.sort.nil? 
					@order.sort=0;
				else
					@order.sort += 1;	
				end	
				@order.load=fload;
				@order.save;
			end	
		end	
		@loads = Load.where("date >= current_date").all;
		if !@order.load.nil?
			@userInfo = 'Order No '+@order.number+'  placed into '+
				@order.load.date.strftime("%m/%d/%Y")+' '+@order.load.timeshift.name;
		else
			@userInfo = 'Appropriate load not found. Please crete appropriate load...'
		end	
		logger.info('userInfo = '+@userInfo);
		respond_to do |format|
			format.js
		end	
	end	

	def saveOrder
		client = Client.find_by(name: params['client']['name'], phone: params['client']['phone']);
		if client.nil?
			client = Client.create(:name => params['client']['name'],:phone => params['client']['phone']);
		end	
		dest_city = City.find_by(name: params['city']['name']); #Полагаем что названия городов все-таки уникальны, хотя можно добавить проверку еще по стране или штату
		state=nil;
		if params['city']['state_id']!=""
			state = State.find(params['city']['state_id']);
		else 
			state= State.find(1);#Default value for addresses
		end
		if dest_city.nil?
			dest_city = City.create(:name => params['city']['name'], :state => state);	
		end	
		dest_address = Address.find_by(city: dest_city, rawline: params['address']['rawline'], zip: params['address']['zip']);	
		if dest_address.nil?
			dest_address = Address.create(:rawline => params['address']['rawline'], :zip => params['address']['zip'], :city => dest_city);	
		end	
		@order.client = client;
		@order.origin_id = params['order']['origin_id'];
		@order.address = dest_address;
		@order.timeshift_id=params['order']['timeshift_id'];
		@order.prefdate=Date.strptime(params['order']['prefdate'],'%m/%d/%Y') rescue nil;
		@order.quantity = params['order']['quantity'];
		@order.volume = params['order']['volume'];
		@order.number = params['order']['number'];
		if (params['load_id'].nil?)||(params['load_id']=="")
			logger.info("1");
			@order.load=nil
		else	
			logger.info("2");
			@order.load_id = params['load_id'].to_i;
		end;
		logger.info("%%%%%%%%%%%%%% load_id="+@order.load_id.to_s);	
		@order.save;
	end;	

	def up
		rOrder = Order.where('load_id=:load_id and sort<:src_sort',{load_id: @order.load_id, src_sort: @order.sort}).order(sort: :desc).first;
		if !rOrder.nil? 
			t = @order.sort;
			@order.sort=rOrder.sort;
			rOrder.sort = t;
			@order.save;
			rOrder.save;
			respond_to do |format|
	  			format.js
			end
		end	
	end
	
	def down
		rOrder = Order.where('load_id=:load_id and sort>:src_sort',{load_id: @order.load_id, src_sort: @order.sort}).order(:sort).first;
		if !rOrder.nil?		
			t = @order.sort;
			@order.sort=rOrder.sort;
			rOrder.sort = t;
			@order.save;
			rOrder.save;
			respond_to do |format|
	  			format.js
			end
		end	
	end	

	def destroy
		@order.destroy;
		respond_to do |format|
			format.html { redirect_to getBackURL, notice: 'Order have been deleted successfully...' }
		end	
	end	
	def getBackURL
		if ((params['return_to'].nil?)||(params['return_to']==""))	
			return orders_path
		else
			return loads_path+'/'+@order.load_id.to_s;
		end		
	end	

	def selectLoad
		@avalLoads = Load.all;
		respond_to do |format|
			format.js;
		end	
	end
	
	def removeFromLoad
		@order.load=nil;
		@statusString = getStatusString;
		respond_to do |format|
			format.js;
		end	
	end	

	def fixSelectedLoad
		@order.load_id=params['load_id'];
		@statusString = getStatusString;
		respond_to do |format|
			format.js;
		end	
	end	
	
	private

	def getStatusString
		s = 'Not in routing list. Delivery not planned';
		if ((@order.load!=nil)&&(@order.load.valid))
			s = 'Placed into routing list for '+@order.load.date.strftime('%m/%d/%Y')+' - '+@order.load.timeshift.name+'. Truck: '+@order.load.truck.no;	
		end;	
		return s;
	end	

	def set_order
		@order = Order.find(params['id']);
		@back_url = params['return_to'];
		@statusString = getStatusString;
	end	

end

