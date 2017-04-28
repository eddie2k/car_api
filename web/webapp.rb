require 'sinatra'
require_relative 'webparamparser'
require_relative 'postgresdb'

APP_BIND_ADDRESS = '0.0.0.0'

DBHOST = 'db'
DBPORT= 5432
DBNAME = 'ally_cars'
DBUSER= 'postgres'
DBPASSWORD = 'postgres'

set :bind, APP_BIND_ADDRESS

#Executes the HTTP magic; handles the connections, carries out the logic and returns the responses
get '/cars' do
	#Expected usage:
	#GET /cars?location=51.5444204,-0.22707
	
	paramParser = WebParamParser.new(params)
	if !paramParser.valid()
		halt 400, {'Content-Type' => 'text/plain'}, "Incorrect usage or unsupported location! Usage example: /cars?location=12.345,-1.234"
	end
	
	db = PostgresDb.new(DBHOST, DBPORT, DBNAME, DBUSER, DBPASSWORD)
	json = db.getNClosestCars(paramParser.getLatitude(), paramParser.getLongitude(), 10)
	if(json!=nil)
		status 200
		headers = {'Content-Type' => 'application/json'}
		body json
	else
		halt 400, {'Content-Type' => 'text/plain'}, "Sorry, we couldn't find 10 suitable cars for your location"
	end
end
