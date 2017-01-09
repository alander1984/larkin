class ImportControllerWorker

  include Sidekiq::Worker
  
  def perform(import_id)
	#Тут немного быдлокода, ибо надо сильно нормализовать данные. Нормализуем до 3 НФ  		
  		import = Import.find(import_id);
  		csv_text = import.attach.to_file;
		csv = CSV.parse(csv_text, :headers => true);
  		csv.each do |arr|
			@order = Order.new;
			@order.number = arr['purchase_order_number'];
			if !arr['delivery_date'].nil?
				@order.prefdate = Date.strptime(arr['delivery_date'],'%m/%d/%Y');
			end	
			@order.volume = arr['volume'];
			@order.quantity = arr['handling_unit_quantity'];
			#<Ищем существующий timeshift>
			t = Timeshift.find_by(code: arr['delivery_shift']);
			if t.nil? 
				t = Timeshift.create(:code => arr['delivery_shift'], :name => arr['delivery_shift']);
			end	
			@order.timeshift = t;	
			#</timeshift>
			#<origin>
			origin_country = Country.find_by(name: arr['origin_country']);
			if origin_country.nil?
				origin_country = Country.create(:name => arr['origin_country']);
			end	
			origin_state = State.find_by(name: arr['origin_state']);
			if origin_state.nil?
				origin_state = State.create(:name => arr['origin_state'], :country => origin_country);	
			end	
			origin_city = City.find_by(name: arr['origin_city']); #Полагаем что названия городов все-таки уникальны, хотя можно добавить проверку еще по стране или штату
			if origin_city.nil?
				origin_city = City.create(:name => arr['origin_city'], :state => origin_state);	
			end	
			origin_address = Address.find_by(city: origin_city, rawline: arr['origin_raw_line_1'], zip: arr['origin_zip']);	
			if origin_address.nil?
				origin_address = Address.create(:rawline => arr['origin_raw_line_1'], :zip => arr['origin_zip'], :city => origin_city);	
			end	
			origin = Origin.find_by(name: arr['origin_name'], address: origin_address);
			if origin.nil?
				origin = Origin.create(:name => arr['origin_name'], :address => origin_address);	
			end	
			#</origin>
			#<client>
			client = Client.find_by(name: arr['client name'], phone: arr['phone_number']);
			if client.nil?
				client = Client.create(:name => arr['client name'],:phone => arr['phone_number']);
			end	
			#</client>
			#<dest>
			dest_country = Country.find_by(name: arr['destination_country']);
			if dest_country.nil?
				dest_country = Country.create(:name => arr['destination_country']);
			end	
			dest_state = State.find_by(name: arr['destination_state']);
			if dest_state.nil?
				dest_state = State.create(:name => arr['destination_state'], :country => dest_country);	
			end	
			dest_city = City.find_by(name: arr['destination_city']); #Полагаем что названия городов все-таки уникальны, хотя можно добавить проверку еще по стране или штату
			if dest_city.nil?
				dest_city = City.create(:name => arr['destination_city'], :state => dest_state);	
			end	
			dest_address = Address.find_by(city: dest_city, rawline: arr['destination_raw_line_1'], zip: arr['destination_zip']);	
			if dest_address.nil?
				dest_address = Address.create(:rawline => arr['destination_raw_line_1'], :zip => arr['destination_zip'], :city => dest_city);	
			end	
			#</dest>
			@order.client = client;
			@order.origin = origin;
			@order.address = dest_address;
			@order.save;

		end;	
	end	
end