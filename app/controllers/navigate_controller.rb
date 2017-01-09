class NavigateController < ApplicationController
  def start
  	if current_worker!= nil
  		if current_worker.roles.find_by(code: "disp")!=nil 
  		#Если пользователь диспетчер - редиректим на страницу для управления загрузками
  		#Тут еще нет проверки для случая, если у пользователя совсем нет ролей, но это будет todo
  			respond_to do |format|
	    		format.html { redirect_to disp_start_path } 
	    	end	
  		else
      #Если пользователь - водитель 
        current_worker.roles.find_by(code: "driver")!=nil 
        respond_to do |format|
          format.html { redirect_to loads_path } 
        end 
  		end	
  	end	
  end

  def controlPanel
    
  end  

  def clearBase
    Order.delete_all;
    Load.delete_all;
    respond_to do |format|
      format.js
    end  
  end  

  def showUsers
  end  

end
