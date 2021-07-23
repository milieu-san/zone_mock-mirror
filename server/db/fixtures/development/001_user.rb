
100.times do |n|
  User.seed do |s|
    s.uid = "test#{n}@test.com"
    s.id = 999_999 + n
    s.name = "test_user_#{n}"
    s.email = "test#{n}@test.com"
    s.password = "asdfasdf"
  end
end
