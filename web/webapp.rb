require 'sinatra'
require_relative 'webparamparser'
require_relative 'postgresdb'
require_relative 'errors'

APP_BIND_ADDRESS = '0.0.0.0'

NUMBER_OF_CARS = 10

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

	begin
	    db = PostgresDb.new(DBHOST, DBPORT, DBNAME, DBUSER, DBPASSWORD)
	    json = db.getNClosestCars(paramParser.getLatitude(), paramParser.getLongitude(), NUMBER_OF_CARS)
	    status 200
	    headers = {'Content-Type' => 'application/json'}
	    body json
    rescue IOError => e
		    halt 503, {'Content-Type' => 'text/plain'}, "Error connecting to the database"
    rescue NotEnoughCarsError => e
		    halt 400, {'Content-Type' => 'text/plain'}, "Sorry, we couldn't find "+ NUMBER_OF_CARS + " suitable cars for your location"
    end
end
