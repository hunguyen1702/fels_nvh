# User
User.create! name: "Nguyen Viet Hung",
  email: "example@fels.com",
  password_digest: "123123",
  role: 0

40.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@fels.com"
  password = "123123"
  User.create! name: name,
    email: email,
    password_digest: password
end

# Activity
users = User.order(:created_at).take 5

10.times do
  action_type = rand(1..4)
  description = Faker::Educator.university * 5
  users.each{|user| user.activities.create! action_type: action_type,
    description: description}
end

# Category
20.times do
  name = Faker::Book.title
  description = Faker::Educator.university * 5
  Category.create! name: name,
    description: description
end

# Word
categories = Category.order(:created_at).take 5
20.times do
  content = Faker::Superhero.descriptor
  categories.each{|category| category.words.create! content: content}
end

# Example
Word.find_each do |word|
  4.times do
    content = Faker::Superhero.descriptor * 2
    word.examples.create! content: content
  end
end

# Answer
Word.find_each do |word|
  content = Faker::Superhero.descriptor * 2
  word.answers.create! content: content, is_correct: true
  3.times do
    content = Faker::Superhero.descriptor * 2
    word.answers.create! content: content, is_correct: false
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
      lesson.status = rand(1..4)
      lesson.save if lesson.valid?
    end
  end
end

# Result
lessons = Lesson.order(:created_at).take 10
lessons.each do |lesson|
  15.times do |n|
    word = lesson.category.words[n]
    answer = word.answers[rand(1..4)]

    result = Result.new
    result.lesson = lesson
    result.word = word
    result.answer = answer
    result.save if result.valid?
  end
end
