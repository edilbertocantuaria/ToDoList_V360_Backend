User.destroy_all
TaskList.destroy_all
Tag.destroy_all
Task.destroy_all

# Criação dos usuários
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

# Criação das tags
tag1 = Tag.create!(tag_name: "Trabalho", user: user1)
tag2 = Tag.create!(tag_name: "Pessoal", user: user2)
tag3 = Tag.create!(tag_name: "Estudo", user: user1)

# Criação das listas de tarefas e tarefas para o usuário 1
task_lists_user1 = [
  { title: "Lista de Trabalho", attachment: "https://conasems-ava-prod.s3.sa-east-1.amazonaws.com/aulas/ava/dummy-1641923583.pdf", tag: tag1, tasks: [
      { description: "Concluir o relatório anual", is_done: false },
      { description: "Preparar a reunião de segunda-feira", is_done: true }
    ] },
  { title: "Lista de Estudos", attachment: nil, tag: tag3, tasks: [
      { description: "Estudar Ruby on Rails", is_done: false },
      { description: "Fazer o projeto final", is_done: true }
    ] },
  { title: "Lista de Projetos", attachment: nil, tag: tag1, tasks: [
      { description: "Finalizar o código da feature X", is_done: false },
      { description: "Revisar o pull request do colega", is_done: true }
    ] },
  { title: "Lista de Tarefas Domésticas", attachment: nil, tag: tag1, tasks: [
      { description: "Limpar a cozinha", is_done: false },
      { description: "Arrumar o quarto", is_done: true }
    ] },
  { title: "Lista de Cursos Online", attachment: nil, tag: tag3, tasks: [
      { description: "Assistir aula de Machine Learning", is_done: false },
      { description: "Completar o curso de Docker", is_done: true }
    ] },
  { title: "Lista de Viagens", attachment: nil, tag: tag1, tasks: [
      { description: "Planejar viagem para o Rio de Janeiro", is_done: false },
      { description: "Reservar hotel em São Paulo", is_done: true }
    ] },
  { title: "Lista de Leitura", attachment: nil, tag: tag3, tasks: [
      { description: "Ler 'Clean Code'", is_done: false },
      { description: "Finalizar 'Design Patterns'", is_done: true }
    ] },
  { title: "Lista de Compras", attachment: nil, tag: tag1, tasks: [
      { description: "Comprar frutas e vegetais", is_done: false },
      { description: "Comprar utensílios de cozinha", is_done: true }
    ] },
  { title: "Lista de Filmes", attachment: nil, tag: tag3, tasks: [
      { description: "Assistir 'O Poderoso Chefão'", is_done: false },
      { description: "Rever 'Matrix'", is_done: true }
    ] },
  { title: "Lista de Séries", attachment: nil, tag: tag3, tasks: [
      { description: "Terminar 'Breaking Bad'", is_done: false },
      { description: "Começar 'Dark'", is_done: true }
    ] },
  { title: "Lista de Restaurantes", attachment: nil, tag: nil, tasks: [
      { description: "Experimentar o novo restaurante japonês", is_done: false },
      { description: "Ir ao restaurante mexicano", is_done: true }
    ] },
  { title: "Lista de Exercícios", attachment: nil, tag: tag1, tasks: [
      { description: "Fazer 30 minutos de cardio", is_done: false },
      { description: "Praticar yoga por 20 minutos", is_done: true }
    ] },
  { title: "Lista de Hobbies", attachment: nil, tag: nil, tasks: [
      { description: "Pintar um quadro", is_done: false },
      { description: "Praticar violão", is_done: true }
    ] },
  { title: "Lista de Podcasts", attachment: nil, tag: tag3, tasks: [
      { description: "Ouvir episódio sobre inteligência artificial", is_done: false },
      { description: "Escutar podcast sobre startups", is_done: true }
    ] },
  { title: "Lista de Compras Tecnológicas", attachment: nil, tag: tag1, tasks: [
      { description: "Comprar um novo monitor", is_done: false },
      { description: "Pesquisar preços de laptops", is_done: true }
    ] },
  { title: "Lista de Ferramentas de Trabalho", attachment: nil, tag: tag1, tasks: [
      { description: "Testar nova ferramenta de deploy", is_done: false },
      { description: "Configurar ambiente de desenvolvimento", is_done: true }
    ] },
  { title: "Lista de Livros Técnicos", attachment: nil, tag: tag3, tasks: [
      { description: "Ler 'Refactoring'", is_done: false },
      { description: "Finalizar 'The Pragmatic Programmer'", is_done: true }
    ] },
  { title: "Lista de Ferramentas DevOps", attachment: nil, tag: tag1, tasks: [
      { description: "Explorar ferramentas como Kubernetes", is_done: false },
      { description: "Configurar Jenkins no projeto", is_done: true }
    ] },
  { title: "Lista de Frameworks JS", attachment: nil, tag: tag3, tasks: [
      { description: "Aprender Vue.js", is_done: false },
      { description: "Testar Next.js em um projeto", is_done: true }
    ] },
  { title: "Lista de Conferências", attachment: nil, tag: tag1, tasks: [
      { description: "Assistir à conferência de tecnologia online", is_done: false },
      { description: "Participar do evento de DevOps", is_done: true }
    ] },
  { title: "Lista de Eventos Acadêmicos", attachment: nil, tag: tag3, tasks: [
      { description: "Submeter artigo para a conferência acadêmica", is_done: false },
      { description: "Revisar material para o evento", is_done: true }
    ] },
  { title: "Lista de Projetos Open Source", attachment: nil, tag: tag1, tasks: [
      { description: "Contribuir para projeto open source no GitHub", is_done: true },
      { description: "Revisar código de um repositório open source", is_done: false },
      { description: "Abrir MR referente a issue F-543", is_done: true }
    ] },
  { title: "Lista de Músicas", attachment: nil, tag: nil, tasks: [
      { description: "Montar uma playlist de músicas para relaxar", is_done: true },
      { description: "Ouvir nova música de uma banda favorita", is_done: true }
    ] },
  { title: "Lista de Artigos Científicos", attachment: nil, tag: tag3, tasks: [
      { description: "Ler artigo sobre inteligência artificial", is_done: true },
      { description: "Revisar artigo sobre ciência de dados", is_done: true }
    ] }
]

task_lists_user1.each do |task_list_data|
  task_list = TaskList.create!(
    title: task_list_data[:title],
    user: user1,
    attachment: task_list_data[:attachment],
    tag: task_list_data[:tag]
  )

  task_list_data[:tasks].each do |task_data|
    Task.create!(
      task_list: task_list,
      task_description: task_data[:description],
      is_task_done: task_data[:is_done]
    )
  end
end

# Criação das listas de tarefas e tarefas para o usuário 2
task_lists_user2 = [
  { title: "Lista de Tarefas Pessoais", attachment: "https://conasems-ava-prod.s3.sa-east-1.amazonaws.com/aulas/ava/dummy-1641923583.pdf", tag: tag2, tasks: [
      { description: "Comprar presentes de Natal", is_done: false },
      { description: "Agendar consulta médica", is_done: true }
    ] }
]

task_lists_user2.each do |task_list_data|
  task_list = TaskList.create!(
    title: task_list_data[:title],
    user: user2,
    attachment: task_list_data[:attachment],
    tag: task_list_data[:tag]
  )

  task_list_data[:tasks].each do |task_data|
    Task.create!(
      task_list: task_list,
      task_description: task_data[:description],
      is_task_done: task_data[:is_done]
    )
  end
end

puts "Seed concluído com sucesso!"
