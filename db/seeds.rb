# User
User.create! name: "Nguyen Viet Hung",
  email: "example@fels.com",
  password: "123123",
  password_confirmation: "123123",
  role: 1,
  is_activated: true

40.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@fels.com"
  password = "123123"
  User.create! name: name,
    email: email,
    password: password,
    password_confirmation: password,
    is_activated: true
end

# Activity
users = User.order(:created_at).take 5

10.times do
  action_type = rand(0..3)
  description = Faker::Educator.university * 5
  users.each{|user| user.activities.create! action_type: action_type,
    description: description}
end

# Category
20.times do |n|
  name = Faker::Book.title + n.to_s
  description = Faker::Educator.university * 5
  Category.create! name: name,
    description: description
end

# Word & Answers
categories = Category.order(:created_at).take 5
20.times do |n|
  content = Faker::Superhero.descriptor + n.to_s
  categories.each do |category|
    word = category.words.build
    word.content = content + n.to_s
    content = Faker::Superhero.descriptor * 2
    word.answers << Answer.new(content: content, is_correct: true)
    3.times do
      content = Faker::Superhero.descriptor * 2
      word.answers << Answer.new(content: content, is_correct: false)
    end
    word.save
  end
end

# Example
Word.find_each do |word|
  4.times do
    content = Faker::Superhero.descriptor * 2
    word.examples.create! content: content
  end
end

# Lesson
users = User.order(:created_at).take 5
categories = Category.order(:created_at).take 3
users.each do |user|
  categories.each do |category|
    2.times do
      lesson = Lesson.new
      lesson.user = user
      lesson.category = category
      lesson.status = 2
      lesson.save if lesson.valid?
    end
  end
end

# Result
lessons = Lesson.order(:created_at).take 10
lessons.each do |lesson|
  5.times do |n|
    word = lesson.category.words[n]
    answer = word.answers[rand(0..3)]

    result = Result.new
    result.lesson = lesson
    result.word = word
    result.answer = answer
    result.save if result.valid?
  end
end
