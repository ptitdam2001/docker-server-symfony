Run the container with a local path

docker run -d -p 8080:80 --name local-server ptitdam2001/server-symfony -v /Users/dan/site:/var/www/site