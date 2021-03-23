# docker-php-phalcon

## Description

Simple Apache server with PHP 7.2, PHALCON 3 e some other libs for a personal project.

## Usage

docker build --no-cache -t docker-php-phalcon:php72-phalcon3 . 

docker run -p 80:80 --name docker-php-phalcon -d docker-php-phalcon:php72-phalcon3 
