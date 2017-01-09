class Load < ActiveRecord::Base
	belongs_to :truck
	belongs_to :worker
	belongs_to :timeshift
	has_many :orders

	def loadedPercent
		result = 0;
		if truck!=nil
			if truck.volume!=0
				result = 100*Order.where("load_id = :load_id", {load_id: id}).sum('volume')/truck.volume;
			end
		end
		return result.round(1)	
	end	

	def avalVolume
		result = 0; #Если грузовика нет - то не грузим ничего. Также не грузим, если не определены остальные параметры
		if valid
			result= truck.volume-Order.where("load_id = :load_id", {load_id: id}).sum('volume')
		end
		return result	
	end	

	def valid
		return ((!date.blank?)&&(timeshift!=nil)&&(truck!=nil)&&(worker!=nil))
	end	

	def validRest #Проверяем есть ли для данной загрузке предварительный отдых
		#Так как количество окон зафиксировано, то коэффициенты 3(количество интервалов в дне) зашито непосредственно в запрос. 
		#При параметризации можно будет вытащить
		nearestLoad = Load.joins(:timeshift).
			where("(truck_id=:truck_id or worker_id=:worker_id) and loads.id<>:load_id and
				 ((date::date-cast(:date as date)::date)+(cast(num as float)-cast(:num as float))/3)<=0",
				 {truck_id: truck_id, worker_id: worker_id, load_id: id, date: date, num: timeshift.num}).
			select("loads, (date::date-cast('"+date.to_s+"' as date)::date)+(cast(num as float)-cast('"+timeshift.num.to_s+"' as float))/3 as diff").
			order("((date::date-cast(current_Date as date)::date)+cast(num as float))/3").last;
		if nearestLoad.nil?
			return true	
		else	
			logger.info('------------------------'+nearestLoad.diff.to_s);
			return !((nearestLoad.diff)>-0.5)&&(((nearestLoad.diff)<=0))
			# тут вообще можно проверять на 0.6666666, но 0.5 в случае фиксированных интервалов вернее
		end
	end	
end