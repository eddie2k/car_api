In order to make things easier some steps have been scripted, but software must be manually installed and configured. Please, follow the steps below to run the system:

1. Set up a PostgreSQL database engine and add the PostGIS extension (tested with PostgreSQL 9.5 and PostGIS 2.2.1). Detailed instructions can be found at http://www.bostongis.com/PrinterFriendly.aspx?content_name=postgis_tut01 .
2. Create a new database and name it "ally_cars". The user and password should both be "postgres". You can modify the code to adapt it to your current setup, if needed.
3. Run the SQL code from "setup_db.sql". It will create a schema and a table with the required configuration.
4. Add sample data in the database. Simply run the script named "fill_db.sql" and around 30k real locations will be added.
5. Run the ruby script "cars.rb" and access the server via browser to test it: http://localhost:4567/cars?location=51,-0.22707