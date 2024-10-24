User.destroy_all
TaskList.destroy_all
Tag.destroy_all
Task.destroy_all

user1 = User.create!(
  name: "Edilberto",
  email: "edilberto@example.com",
  password: "password123",
  password_confirmation: "password123",
  user_picture: "https://this-person-does-not-exist.com/img/avatar-gen851f9c29e5f6857320e36f7359c01c5b.jpg"
)

user2 = User.create!(
  name: "Maria",
  email: "maria@example.com",
  password: "password456",
  password_confirmation: "password456",
  user_picture: "https://this-person-does-not-exist.com/img/avatar-gen4e1a0a1daffae1239fe54c59b1003ba4.jpg"
)

tag1 = Tag.create!(tag_name: "Trabalho", user: user1)
tag2 = Tag.create!(tag_name: "Pessoal", user: user2)
tag3 = Tag.create!(tag_name: "Estudo", user: user1)

task_list1 = TaskList.create!(
  title: "Lista de Trabalho",
  user: user1,
  attachment: "https://conasems-ava-prod.s3.sa-east-1.amazonaws.com/aulas/ava/dummy-1641923583.pdf",
  tag: tag1
)

task_list2 = TaskList.create!(
  title: "Lista de Estudos",
  user: user1,
  attachment: nil,
  tag: tag3
)

task_list3 = TaskList.create!(
  title: "Lista de Tarefas Pessoais",
  user: user2,
  attachment: "https://conasems-ava-prod.s3.sa-east-1.amazonaws.com/aulas/ava/dummy-1641923583.pdf",
  tag: tag2
)

task1 = Task.create!(
  task_list: task_list1,
  task_description: "Concluir o relatório anual",
  is_task_done: false
)

task2 = Task.create!(
  task_list: task_list1,
  task_description: "Preparar a reunião de segunda-feira",
  is_task_done: true
)

task3 = Task.create!(
  task_list: task_list2,
  task_description: "Estudar Ruby on Rails",
  is_task_done: false
)

task4 = Task.create!(
  task_list: task_list2,
  task_description: "Fazer o projeto final",
  is_task_done: true
)

task5 = Task.create!(
  task_list: task_list3,
  task_description: "Comprar presentes de Natal",
  is_task_done: false
)

task6 = Task.create!(
  task_list: task_list3,
  task_description: "Agendar consulta médica",
  is_task_done: true
)

puts "Seed concluído com sucesso!"