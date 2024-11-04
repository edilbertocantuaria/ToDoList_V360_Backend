# To Do List API

This API is designed to manage task lists, enabling users to organize tasks in a structured way. The API supports creating multiple task lists, each containing multiple tasks, and allows for additional functionality such as tagging, file attachments, and route authentication. 

## Example Use Case

A user logs into the application to create a new project under their task lists. Within this project, they can add tasks with descriptions, assign tags to categorize these tasks, and attach relevant files for easy access. They can filter tasks by tags or due dates and mark tasks as complete when finished. All data is secure, as only authenticated users have access to their respective task lists and tasks.

**API Documentation**
   - Detailed API documentation is available [here](doc\usage.md) for easy integration and understanding of available endpoints, parameters, and response formats.


## Table of Contents
- [To Do List API](#to-do-list-api)
  - [Example Use Case](#example-use-case)
  - [Table of Contents](#table-of-contents)
  - [Pre requisites](#pre-requisites)
  - [Instalation](#instalation)
  - [Running the API (Whithout Docker)](#running-the-api-whithout-docker)
  - [Running the API (Whith Docker)](#running-the-api-whith-docker)
  - [Running tests](#running-tests)
  - [Command Summary Table](#command-summary-table)


---

## Pre requisites

1. **Ruby** - Ensure Ruby is installed. The recommended version can be found in the `Gemfile`.
   - [Install Ruby](https://www.ruby-lang.org/en/documentation/installation/)
   - You can check your Ruby version using `ruby -v` on your teminal.
2. **Rails** - Install the Rails gem.
   ```bash
   gem install rails
   ```
   - You can check your Rails version using `rails -v` on your teminal.
3. **Database** - Make sure the required database (e.g., PostgreSQL, MySQL) is installed and running.

## Instalation 

1. **Clone the repository**
   ```bash
   git clone https://github.com/edilbertocantuaria/ToDoList_V360
   cd ToDoList_V360
   ``` 
2. **Dependencies**: Install dependencies(gems) using bundler
   ```bash
    bundle install
   ``` 
3. **Set Up Environment Variables**
 - Create a `.env` file in the root directory and add required environment variables.
 - Refer to `.env.example` for required variables.


## Running the API (Whithout Docker)
1. **Database Set Up**: Create and migrate the database.
    ```bash
    rails db:create
    rails db:migrate
    ```
- Additionally you can seed:
  ```bash
  rails db:sedd
  ```

2. **Start the rails Server**
   ```bash
    rails server
   ``` 
- The server will start at http://localhost:3000 by default.
3. **Access API Documentation**
- Visit http://localhost:3000/up on your browser. If you see a green screen, it means your API is running!

## Running the API (Whith Docker)

1. **Build the image and containers**: 
- Run the following command to build the Docker image and start the containers:
    ```bash
    docker compose up --build
    ```

2. **Database Set Up**: Create and migrate the database.
    ```bash
    docker-compose exec app rails db:create db:migrate
    ```
- Additionally you can seed:
  ```bash
  docker-compose exec app rails db: seed
  ```
- The server will start at http://localhost:3000 by default.
  
3. **Access API Documentation**
- Visit http://localhost:3000/up on your browser. If you see a green screen, it means your API is running!

## Running tests

1. To run tests, use:
    ```bash 
       rails test
    ```
    This comand should create a new folder called `coverage` with a `.html` file that displays the line-by-line test coverage. 

2. To run a specific test, use:
    ```bash 
       rails test <path_name>
    ```
    for exemple, to run all tests in the `models` folder:
    ```bash 
       rails test models
    ```
    Or to run just `task_lists_controller_test.rb` file: 
    ```bash 
       rails test task_lists_controller_test.rb
    ```

## Command Summary Table


| Task                              | Command                                                                                       |
|-----------------------------------|-----------------------------------------------------------------------------------------------|
| **Check Ruby version**            | `ruby -v`                                                                                    |
| **Check Rails version**           | `rails -v`                                                                                   |
| **Install Rails**                 | `gem install rails`                                                                          |
| **Clone repository**              | `git clone https://github.com/edilbertocantuaria/ToDoList_V360`                               |
| **Install dependencies**          | `bundle install`                                                                             |
| **Create database**               | `rails db:create`                                                                            |
| **Migrate database**              | `rails db:migrate`                                                                           |
| **Seed database**                 | `rails db:seed`                                                                              |
| **Start Rails server**            | `rails server`                                                                               |
| **Docker: Build & Start**         | `docker-compose up --build`                                                                  |
| **Docker: Create & Migrate DB**   | `docker-compose exec app rails db:create db:migrate`                                         |
| **Docker: Seed Database**         | `docker-compose exec app rails db:seed`                                                      |
| **Run all tests**                 | `rails test`                                                                                 |
| **Run specific test**             | `rails test <path_to_test_file>`                                                             |
| **Run all model tests**           | `rails test models`                                                                          |
| **Run specific controller test**  | `rails test test/controllers/task_lists_controller_test.rb`                                  |
