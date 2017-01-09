class AddSomeTracks < ActiveRecord::Migration
  def up
  	#Добавляем пару грузовичков
	Truck.create :id =>1, :no => '514', :volume => 1400;
	Truck.create :id =>2, :no => '861', :volume => 1400;
  end

  def down
  	Truck.destroy(1);
  	Truck.destroy(2);
  end
  	
end
