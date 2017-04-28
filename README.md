The deployment of the application is fully automated using Docker. Assuming docker-compose is installed and ready, simply follow next steps to make it work.

1. Build and run the docker containers. Execute:
```
docker-compose build
docker-compose up -d
```
2. Access the server via browser or preferred client to test it (e.g.:  http://localhost:34001/cars?location=51,-0.22707). The database is initialized with around 30k real locations. It might take a while until a 400-Ok is returned; until that moment, you'll get back 503-Service Unavailable.
3. Once you're done, you can stop the containers using
```
docker-compose stop
docker-compose rm
```
