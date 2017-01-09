class IntegrationsController < ApplicationController
	def csvImport	
		@import = Import.new;
	end	
end
