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
end

And(/^give a role to that user$/) do
  Role.create(user: @new_user, name: 5)
end

Then(/^log in user with basic auth email and password$/) do
  user = User.find_by(email: @new_user.email)
end

Then(/^I send the correct parameters to the issue_report endpoint$/) do
  agency = Agency.create(name: Faker::Name.name, company: @company)
  residence = Residence.create(name: Faker::Name.name, agency: agency, company: @company)
  place = Place.create(name: Faker::Name.name, zip: Faker::Address.zip_code, city: Faker::Address.city, country: Faker::Address.country, company: @company, residence: residence)


  location_type = LocationType.create(name: Faker::Name.name, nature: 0, company: @company)
  issue_type = IssueType.create(name: Faker::Name.name, location_type: location_type, company: @company)

  header 'Authorization', "Bearer #{generate_token(@new_user)}"
  params = {
    data: {
      type: "issue_reports",
      attributes: {
        priority: 'medium',
        message: Faker::Quote.jack_handey,
        company_id: @company.id,
        author_id: @new_user.id,
        place_id: place.id,
        issue_type_id: issue_type.id,
      }
    }
  }
  res = send :post, '/issue_reports', params
  expect(res.status).to eq(201)

end
