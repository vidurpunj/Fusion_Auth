class UserController < ApplicationController
  def register
    object = {
      "registration": {
        "applicationId": "e4bc44b7-feed-4f73-93d8-a966dcffa200",
        "email": "example@fusionauth.io",
        "encryptionScheme": "salted-sha256",
        "factor": 24000,
        "expiry": 1571786483322,
        "firstName": "John",
        "fullName": "John Doe",
        "imageUrl": "http://65.media.tumblr.com/tumblr_l7dbl0MHbU1qz50x3o1_500.png",
        "lastName": "Doe",
        "middleName": "William",
        "mobilePhone": "303-555-1234",
        "password": "supersecret",
        "passwordChangeRequired": false,
        "timezone": "America/Denver",
        "usernameStatus": "ACTIVE",
        "username": "johnny123"
      }
    }
    @fusion_response = HTTParty.post('http://localhost:9011/api/user/registration/cfa74439-7171-402d-b0c7-ca62d98132b4', body: object.to_json,
                             :headers => { 'Content-Type' => 'application/json',
                                           'X-FusionAuth-TenantId' => '5fb699ef-f22d-46c5-9d2a-0289ee7bbe7e',
                                           'Authorization' => 'Z788oDfRiOGYi9sd6VlrCcywceZxwFInltb7aSVQI7LWYHqavId0apfl'
                             })
    puts "Response"
    puts response
    puts response.body, response.code, response.message, response.headers.inspect
  end

  def create
    object = {
      "applicationId": "e4bc44b7-feed-4f73-93d8-a966dcffa200",
      "disableDomainBlock": false,
      "user": {
        "birthDate": "1976-05-30",
        "data": {
          "displayName": "Johnny Boy",
          "favoriteColors": [
            "Red",
            "Blue"
          ]
        },
        "email": "vidur.punj1@hotmail.com",
        "encryptionScheme": "salted-sha256",
        "factor": 24000,
        "expiry": 1571786483322,
        "firstName": "John",
        "fullName": "John Doe",
        "imageUrl": "http://65.media.tumblr.com/tumblr_l7dbl0MHbU1qz50x3o1_500.png",
        "lastName": "Doe",
        "middleName": "William",
        "mobilePhone": "303-555-1234",
        "password": "supersecret",
        "passwordChangeRequired": false,
        "preferredLanguages": [
          "en",
          "fr"
        ],
        "timezone": "America/Denver",
        "twoFactor": {
          "methods": [
            {
              "authenticator": {
                "algorithm": "HmacSHA1",
                "codeLength": 6,
                "timeStep": 30
              },
              "secret": "aGVsbG8Kd29ybGQKaGVsbG8gaGVsbG8=",
              "method": "authenticator"
            },
            {
              "method": "sms",
              "mobilePhone": "555-555-5555"
            },
            {
              "method": "email",
              "email": "example@fusionauth.io"
            }
          ]
        },
        "usernameStatus": "ACTIVE",
        "username": "johnny123"
      }
    }
    @fusion_create_response = HTTParty.post('http://localhost:9011/api/user/', body: object.to_json,
                                     :headers => { 'Content-Type' => 'application/json',
                                                   'X-FusionAuth-TenantId' => '5fb699ef-f22d-46c5-9d2a-0289ee7bbe7e',
                                                   'Authorization' => 'Z788oDfRiOGYi9sd6VlrCcywceZxwFInltb7aSVQI7LWYHqavId0apfl'
                                     })
  end
end
