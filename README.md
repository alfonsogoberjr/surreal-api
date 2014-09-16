Surreal-API
=========

A node.js REST API

  - nodejs (duh) + expressjs
  - passportjs for auth (LocalStrategy, BearerStrategy represented)
  - mongoosejs for talking to mongodb
  - SockJS for socket based power
  - mocha for unit testing
  

Version
-

0.1.0

##Requirements

 - Install Node.js at http://nodejs.org/
 - Install mocha unit testing (`npm install -g mocha`)
 - Install Coffeescript (`npm install -g coffee-script`)
 - Install nodemon (`npm install -g nodemon`)
 - Install mongodb at http://www.mongodb.org/downloads


##Getting Started

 - From within the root (surreal-api/) directory
 	
		npm install

 - start the server
 
 		nodemon server.coffee  
 		
 - Create an account

		curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{ "email": "your@email.com", "name": "Your Name", "admin": true, "password": "yourpassword", "passwordConfirm": "yourpassword" }'  http://localhost:5008/api/user/register

	You'll get a response: 

		"User Your Name (your@email.com) Created"

 - go ahead and give it a try--login:
 
 		curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{ "email": "your@email.com", "password": "yourpassword" }'  http://localhost:5008/api/user/login

	If successful, you'll get a response:

		{
		  "success": "Logged in.",
		  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.IjY5M2M0MDQ5Mjk1Zjk3ZWY5ZDkxNzc0YzczMmQxNmU2Ig.JMmUbTOs59sa2XffxoFBaqbSwHgWfjSZ-dZJeOa3q-s",
		  "name": "Your Name"
		}

	You'll receive a response that contains the token you'll use for subsequent requests that require authentication. The access_token parameter must be included in every request, like so: 
	
		curl -H "Accept: application/json" -H "Content-type: application/json" http://localhost:5008/api/user?access_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.IjY5M2M0MDQ5Mjk1Zjk3ZWY5ZDkxNzc0YzczMmQxNmU2Ig.JMmUbTOs59sa2XffxoFBaqbSwHgWfjSZ-dZJeOa3q-s
	
##TODO

 - build full User REST endpoints
 - Tighten up user auth with bcrypt

 
