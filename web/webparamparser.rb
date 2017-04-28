#Parses the input parameters and performs validation
class WebParamParser
	LAT_BOUNDS = 90.0
	LON_BOUNDS = 180.0
	
	def initialize(params)
		loc_params=params['location']
		#Syntax validation. It avoids SQL injections as well.
		if loc_params != nil and loc_params.match('(\+|\-)?[\d]+(.[\d]+)?\,(\+|\-)?[\d]+(.[\d]+)?')		
			#Get the params
			splitted = loc_params.split(',')
			param_zeroth = splitted[0].to_f
			param_first = splitted[1].to_f
			if param_zeroth>-LAT_BOUNDS and param_zeroth<LAT_BOUNDS and param_first>-LON_BOUNDS and param_first<LON_BOUNDS
				@lat = param_zeroth
				@lon = param_first
			end
		end
	end
	
	def valid()
		if @lat!=nil and @lon!=nil
			true
		else
			false
		end
	end
	
	def getLatitude()
		return @lat
	end
	
	def getLongitude()
		return @lon
	end
end
