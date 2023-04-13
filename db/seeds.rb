## create user locally and in fusion auth

USER_PASSWORD = 'Bullet@2023'
USER_EMAIL = 'vidur.punj@yopmail.com'
USER_FIRST_NAME= 'Vidur'
USER_LAST_NAME = 'Punj'

object = {
  "applicationId": ENV["FUSION_AUTH_CLIENT_ID"],
  "disableDomainBlock": false,
  "user": {
    "birthDate": "1976-05-30",
    "email": USER_EMAIL,
    "encryptionScheme": "salted-sha256",
    "factor": 24000,
    "firstName": USER_FIRST_NAME ,
    "fullName": USER_FIRST_NAME + ' ' + USER_LAST_NAME,
    "middleName": USER_LAST_NAME,
    "lastName": "Auth",
    "imageUrl": "",
    "mobilePhone": "123-456-7899",
    "password": USER_PASSWORD,
    "passwordChangeRequired": false,
    "preferredLanguages": [
      "en",
      "fr"
    ],
    "timezone": "America/Denver",
    "usernameStatus": "ACTIVE",
    "username": USER_EMAIL
  }
}
@fusion_create_response = HTTParty.post("#{ENV['FUSION_AUTH_APPLICATION_URL']}/api/user/", body: object.to_json,
                                        :headers => { 'Content-Type' => 'application/json',
                                                      'X-FusionAuth-TenantId' => ENV["FUSIONAUTH_TENANT_ID"],
                                                      'Authorization' => ENV["AUTHORIZATION"]
                                        })
if  @fusion_create_response.code.eql?(400)
  ## Get that user form the fusion auth by email
  @fusion_create_response = HTTParty.get("#{ENV['FUSION_AUTH_APPLICATION_URL']}/api/user?email=#{USER_EMAIL}",
                                          :headers => { 'Content-Type' => 'application/json',
                                                        'X-FusionAuth-TenantId' => ENV["FUSIONAUTH_TENANT_ID"],
                                                        'Authorization' => ENV["AUTHORIZATION"]
                                          })
end

@auth_super_admin_user = @fusion_create_response
puts "Message from fusion auth"
puts @fusion_create_response
puts "Super admin is created !!"
@auth_id = @fusion_create_response["user"]["id"]

## register the user also
object = {
  "registration": {
    "applicationId": ENV["FUSION_AUTH_CLIENT_ID"],
    "email": USER_EMAIL,
    "encryptionScheme": "salted-sha256",
    "factor": 24000,
    "expiry": 1571786483322,
    "firstName": "Super",
    "fullName": "Super Admin",
    "imageUrl": "",
    "lastName": "Admin",
    "middleName": "",
    "mobilePhone": "123-456-7899",
    "password": USER_PASSWORD,
    "passwordChangeRequired": false,
    "timezone": "America/Denver",
    "usernameStatus": "ACTIVE",
    "username": USER_EMAIL,
    "roles": [
      "super_admin"
    ],
  }
}
@fusion_register_response = HTTParty.post("#{ENV['FUSION_AUTH_APPLICATION_URL']}/api/user/registration/#{@auth_id}", body: object.to_json,
                                          :headers => { 'Content-Type' => 'application/json',
                                                        'X-FusionAuth-TenantId' => ENV["FUSIONAUTH_TENANT_ID"],
                                                        'Authorization' => ENV["AUTHORIZATION"]
                                          })
puts @fusion_register_response
puts "Super admin is register to the application!!"