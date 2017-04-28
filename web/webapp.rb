require 'sinatra'
require 'pg'
require 'json'
require_relative 'webparamparser'

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

#Interacts with a PostgreSQL database. JSON-friendly.
class PostgresDb
	def initialize(dbhost, dbport, dbname, dbuser, dbpass)
		@dbhost=dbhost
		@dbport=dbport
		@dbname=dbname
		@dbuser=dbuser
		@dbpass=dbpass
	end
	
	def getNClosestCars(lat, lon, n)
		conn = PG.connect(host:@dbhost, port:@dbport, dbname: @dbname, user: @dbuser, password: @dbpass )
		conn_result = conn.exec(getClosetsCarsQuery(lat, lon))
		if conn_result.cmd_tuples==n
			jsonConverter = PgResultsConverter.new(conn_result, "cars")
			json = jsonConverter.toJson
			conn_result.clear
			json
		else
			nil
		end
	end
	
	def getClosetsCarsQuery(lat, lon)
		"SELECT ST_X(coordinates) AS lat, ST_Y(coordinates) AS lon, description FROM ally_cars.cars ORDER BY coordinates <-> ST_SetSRID(ST_MakePoint ('" + lat.to_s + "','" + lon.to_s + "'), 4326) LIMIT 10;"
	end
end

#Converts between PostgreSQL results and JSON
class PgResultsConverter
	def initialize(pg_result, table_alias)
		@pg_result = pg_result
		@table_alias = table_alias
	end
	
	def toJson()
		table = []
		columns = @pg_result.fields()
		@pg_result.each do |row|
			row_json = {}
			columns.each do |column|
				row_json[column] = row.values_at(column).first
			end
			table << row_json
		end
		table_json = {@table_alias => table}
		table_json.to_json
	end
end
