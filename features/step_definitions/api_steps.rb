Given('I create new User') do
  User.create(fname: "test", lname: "test", email: "test@test.com", password: "Coucoutoi", password_confirmation: "Coucoutoi")
end

Given(/^I logged in with email:"(.*)" and password:"(.*)"$/) do |email, password|
  @body = {
    email: email,
    password: password
  }.to_json
  @response = RegisterService.post '/sign-in', body: @body
end

Then('I get the token') do
  RegisterService.headers['Authorization'] = @response['auth']
end

Given('that I send the correct parameters to the companies endpoint') do
  @body = {
    name: Faker::Name.name,
    logo_url: Faker::Avatar.image,
    logo_base64: Faker::Internet.base64
  }.to_json
  p RegisterService.headers

  # byebug
  user_list = RegisterService.get '/users'
  p user_list

  # @post_companies = RegisterService.post '/companies', body: @body
  # puts @post_companies
end

Then('a new company is successfully registered in the database') do
  # @post_companies.headers
  # @post_companies.body
  # expect(@post_companies.code).to eq 201
end
