users = User.all
users.each do |user|
  user.update(status: :active)
end
