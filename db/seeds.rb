User.create!(name: "admin",
             email: "admin@admin.com",
             password: "adminuser",
             password_confirmation: "adminuser",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name: "test",
             email: "test@test.com",
             password: "password",
             password_confirmation: "password",
             activated: true,
             activated_at: Time.zone.now)

35.times do |n|
  name = Faker::Name.name
  email = "test#{n}@test.com"
  password ="password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# #一部のユーザーにやりたいことリストを作成する
# users = User.order(:created_at).take(6)
# 50.times do
#   content = Faker::Lorem.sentence(word_count: 3)
#   users.each { |user| user.list_items.create!(content: content) }
# end