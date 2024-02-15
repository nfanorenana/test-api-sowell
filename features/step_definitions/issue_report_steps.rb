def generate_token(user)
  token = JsonWebToken.encode({ uid: user.id })
  return token
end

Given(/^Creating New Company$/) do
  @company = Company.create(
    name: Faker::Name.name,
    logo_url: Faker::Avatar.image,
    logo_base64: Faker::Internet.base64
  )
end

Then(/^I create a new user$/) do
  @new_user = User.create(
    fname: Faker::Name.name,
    lname: Faker::Name.name,
    email: Faker::Internet.email,
    password_digest: "Coucoutoi",
    company: @company
  )

  p @new_user
end

And(/^give a role to that user$/) do
  Role.create(user: @new_user, name: 5)
end

Then(/^log in user with basic auth email and password$/) do
  user = User.find_by(email: @new_user.email)
  @token = generate_token(user)
end

And(/^get token and add to header$/) do
  HttpService.headers['Authorization'] = "Bearer #{@token}"
end



Then(/^I send the correct parameters to the issue_report endpoint$/) do
  @body = {
    message: Faker::Quote.jack_handey,
    priority: 'medium',
    author_id: @new_user,
    # issue_type_id, :integer
    # place_id, :integer
    # spot_id, :integer
    company_id: @company,
    # visit_report_id, :integer
    # checkpoint_id, :integer
    status: 'ongoing',
    # talks, :array
    imgs: Faker::Avatar.image
  }.to_json
  p HttpService.headers
  @response = HttpService.post '/issue_reports', body: @body
  p @response
end

And(/^a new issue report is successfully registered in the database$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
