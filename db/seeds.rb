Question.destroy_all
User.destroy_all

user1 = User.create(
  email: 'user1@yandex.ru',
  password: 'secret1',
  password_confirmation: 'secret1',
)

user2 = User.create(
  email: 'user2@yandex.ru',
  password: 'secret2',
  password_confirmation: 'secret2',
)

user3 = User.create(
  email: 'user3@yandex.ru',
  password: 'secret3',
  password_confirmation: 'secret3',
)

q1, q2, q3 = Question.create(
  [
    {
      title: 'First programming language',
      body: 'Which programming language is best to learn first?',
      user: user1
    },
    {
      title: 'Programming book for a beginner?',
      body: 'What programming book would you recommend for learning Elixir?',
      user: user2
    },
    {
      title: 'Framework for REST API',
      body: 'What are the best framework to create a REST API in a very short time?',
      user: user3
    }
  ]
)

Answer.create(
  [
    {
      body: 'I have no idea',
      question: q2,
      user: user1
    },
    {
      body: 'What is REST API?',
      question: q3,
      user: user1
    },
    {
      body: 'Structure and Interpretation of Computer Programs',
      question: q1,
      user: user2
    },
    {
      body: 'Ruby on Rails',
      question: q3,
      user: user2
    },
    {
      body: 'Cobol',
      question: q1,
      user: user3
    },
    {
      body: 'Structure and Interpretation of Computer Programs',
      question: q2,
      user: user3
    }
  ]
)
