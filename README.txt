The deployment of the application is fully automated using Docker. Assuming docker-compose is installed and ready, simply follow next steps to make it work.

1. Build and run the docker containers. Execute: docker-compose build; docker-compose up -d
2. Wait until the application is up and ready. The database is initialized with around 30k real locations. It might take a while.
3. Access the server via browser or preferred client to test it: http://localhost:4567/cars?location=51,-0.22707
