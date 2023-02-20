User.create!(name: "admin",
             email: "admin@admin.com",
             password: "adminuser",
             password_confirmation: "adminuser",
             admin: true)

35.times do |n|
  name = Faker::Name.name
  email = "test#{n}@test.com"
  password ="password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end