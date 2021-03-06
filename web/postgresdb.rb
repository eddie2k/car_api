require 'pg'
require 'json'
require_relative 'errors'

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
        begin
            conn = PG.connect(host:@dbhost, port:@dbport, dbname: @dbname, user: @dbuser, password: @dbpass)
		    conn_result = conn.exec(getClosetsCarsQuery(lat, lon, n))
		    if conn_result.cmd_tuples==n
			    jsonConverter = PgResultsConverter.new(conn_result, "cars")
			    json = jsonConverter.toJson
			    conn_result.clear
			    json
		    else
                raise NotEnoughCarsError.new
		    end
        rescue PG::Error => e
            raise IOError.new("Error connecting with the database")
        ensure
            conn.close if conn
        end
	end
	
	def getClosetsCarsQuery(lat, lon, n)
		"SELECT ST_X(coordinates) AS lat, ST_Y(coordinates) AS lon, description FROM ally_cars.cars ORDER BY coordinates <-> ST_SetSRID(ST_MakePoint ('" + lat.to_s + "','" + lon.to_s + "'), 4326) LIMIT " + n.to_s + ";"
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
