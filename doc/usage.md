# Using the Task Management API: Features and Endpoint Guide

This API is designed to manage task lists, enabling users to organize tasks in a structured way. The API supports creating multiple task lists, each containing multiple tasks, and allows for additional functionality such as tagging, file attachments, and route authentication.

### Key Features

1. **Task Lists Management**

   - Users can create, update, delete, and view multiple task lists.
   - Each task list has attributes such as title, tag and file attachment (these last ones are optional).
   - Each task list can contain several individual tasks, allowing users to categorize and manage their activities.
   - You can also check the progress of the check list.

2. **Tasks Management**

   - Tasks can be created, updated, completed, or deleted within each task list.
   - Each task has attributes such as description and status to facilitate detailed tracking.

3. **Tags**

   - Tags allow users to label tasks with keywords, making it easy to filter and organize tasks across different lists.
   - Each task can have multiple tags for categorization (e.g., "urgent," "personal," "work").

4. **File Attachments**

   - Users can attach files to tasks, enabling them to store important documents, images, or resources directly linked to a task.
   - File management includes uploading, downloading, and deleting attachments, with validation for file size and type.

5. **Authentication and Authorization**

   - The API uses route authentication to secure access to resources.
   - Endpoints require valid tokens to ensure only authorized users can access and manage their data.

6. **Requirements and Running**
   - Detailed requirements and how to run is available [here](../README.md).

## Table of Contents

- [User](#user)
- [Task List](#task-list)
- [Task](#task)
- [Tags](#tags)

---

## USER

Each task list is associated with an authenticated user. Authentication is handled via JWT (JSON Web Token).

### Endpoints

- **POST** `/users/signup`

  - **Not Authenticated**
  - Registers a new user in the system.
  - **Request Body:**
    ```json
    {
      "name": "User Name",
      "email": "email@domain.com",
      "password": "password123",
      "password_confirmation": "password123",
      "user_picture": "image_url" // optional
    }
    ```
  - **Rules:**
    - `name`: Required, non-empty string.
    - `email`: Required, valid, and unique.
    - `password`: Required, minimum 6 characters, stored encrypted.
  - **Responses:**
    - **201 Created**: Successful registration.
      ```json
      {
        "idUser": 1,
        "name": "User Name",
        "email": "email@domain.com",
        "userPicture": "image_url",
        "createdAt": "creation_date"
      }
      ```
    - **409 Conflict**: Email already in use.
    - **422 Unprocessable Entity**: Errors in request body format (e.g., invalid email, missing fields).

- **POST** `/users/login`

  - **Not Authenticated**
  - Authenticates a user and generates a JWT token.
  - **Request Body:**
    ```json
    {
      "email": "email@domain.com",
      "password": "password123"
    }
    ```
  - **Rules:**
    - `email` and `password` are required.
  - **Responses:**
    - **201 Created**: Successful login, returns a token.
      ```json
      {
        "token": "TOKEN"
      }
      ```
    - **401 Unauthorized**: Incorrect password.
    - **404 Not Found**: Email not found.
    - **422 Unprocessable Entity**: Errors in request body format (e.g., missing fields).

- **GET** `/users/profile`
  - **Authenticated**
  - Retrieves the authenticated user's profile.
  - **Headers:**
    - `Authorization`: `TOKEN`
  - **Response:**
    - **200 OK**: Returns user profile data.
      ```json
      {
        "idUser": 1,
        "name": "User Name",
        "email": "email@domain.com",
        "taskListsCreated": 2,
        "userPicture": "image_url",
        "createdAt": "creation_date"
      }
      ```
    - **401 Unauthorized**: Missing or invalid token.

## Task List

Users can create, read, update, and delete task lists. Each list can include tasks and a single file attachment that can be replaced or removed.

### Endpoints

- **POST** `/task-lists`

  - **Authenticated**
  - Creates a new task list.
  - **Request Body:**
    ```json
    {
      "task_list": {
        "title": "Automation on Telegram",
        "attachment": null,
        "tag_id": null,
        "tasks_attributes": [
          { "task_description": "Study n8n" },
          { "task_description": "Study Ruby on Rails" },
          { "task_description": "Study automation" }
        ]
      }
    }
    ```
  - **Rules:**
    - `title`: Required, non-empty string.
    - `attachment`: Optional, if provided, must be a valid URL.
    - `tag_id`: Optional, must be a valid number if provided.
  - **Response:**
    - **201 Created**: Successfully created, returns task list details.
      ```json
      {
        "id": 1,
        "title": "Task List Title",
        "attachment": "attachment_url",
        "createdAt": "creation_date",
        "updatedAt": "update_date",
        "idTag": 1, // optional
        "percentage": 0
      }
      ```
    - **401 Unauthorized**: Missing or invalid `Authorization` header.
    - **422 Unprocessable Entity**: Errors in request body format.

- **GET** `/task-lists`

  - **Authenticated**
  - Retrieves all task lists associated with the authenticated user.
  - **Headers:**
    - `Authorization`: `TOKEN`
  - **Response:**
    - **200 OK**: Returns all task lists with associated tasks.
      ```json
      [
        {
          "idTaskList": 1,
          "titleTask": "List Title 1",
          "attachment": "attachment_url_or_null",
          "createdAt": "creation_date",
          "updatedAt": "update_date",
          "percentage": 50,
          "idTag": 1, // optional
          "tasks": [
            {
              "idTask": 1,
              "taskDescription": "Task description 1",
              "isTaskDone": true
            },
            {
              "idTask": 2,
              "taskDescription": "Task description 2",
              "isTaskDone": false
            }
          ]
        }
      ]
      ```
    - **401 Unauthorized**: Missing or invalid `Authorization` header.
    - **Empty Array**: No task lists found for the user.

- **GET** `/task-lists/:listId`

  - **Authenticated**
  - Retrieves details of a specific task list.
  - **Headers:**
    - `Authorization`: `TOKEN`
  - **Response:**
    - **200 OK**: Returns task list details.
      ```json
      {
        "idTaskList": "list_id",
        "titleTask": "List Title",
        "idTag": 1, // optional
        "percentage": 50,
        "attachment": "attachment_url",
        "tasks": [
          {
            "idTask": 1,
            "taskDescription": "Task description",
            "isTaskDone": true,
            "createdAt": "creation_date",
            "updatedAt": "update_date"
          }
        ]
      }
      ```
    - **401 Unauthorized**: Missing or invalid `Authorization` header.
    - **404 Not Found**: Task list not found.

- **PUT** `/task-lists/:listId`

  - **Authenticated**
  - Updates a task list's title or attachment.
  - **Request Body:**
    ```json
    {
      "task_list": {
        "title": "New List Title",
        "tag_id": 2, // optional or null
        "attachment": "new_attachment_url" // optional or null
      }
    }
    ```
  - **Rules:**
    - `title`: Required, non-empty string.
    - `attachment`: Optional, if provided, must be a valid URL.
  - **Response:**
    - **200 OK**: Successfully updated.
      ```json
      {
        "idTaskList": 1,
        "title": "New List Title",
        "attachment": "attachment_url",
        "createdAt": "creation_date",
        "updatedAt": "update_date",
        "idTag": 1 // optional
      }
      ```
    - **401 Unauthorized**: Missing or invalid `Authorization` header.
    - **404 Not Found**: Task list not found.
    - **422 Unprocessable Entity**: Errors in request body format.

- **DELETE** `/task-lists/:listId`
  - **Authenticated**
  - Deletes a specific task list along with its tasks and attachment.
  - **Headers:**
    - `Authorization`: `TOKEN`
  - **Response:**
    - **204 No Content**: Successfully deleted.
    - **401 Unauthorized**: Missing or invalid `Authorization` header.
    - **404 Not Found**: Task list not found.

### Attachment

- Each list can have a single attachment, which can be updated or deleted.
- Attachment files can be modified in POST and PUT requests, allowing users to add, replace, or remove the associated file.

## Task

Each task list can contain multiple tasks with full CRUD functionality. Tasks have a completion status and can be edited or removed individually.

### Endpoints

- **POST** `/task-lists/:listId/tasks`

  - **Authenticated**
  - Adds a new task to a specific task list.
  - **Request Body:**
    ```json
    {
      "tasks": [
        {
          "task_description": "Description of new task 1",
          "is_task_done": false
        },
        {
          "task_description": "Description of new task 2",
          "is_task_done": true
        }
      ]
    }
    ```
  - **Rules:**
    - `task_description`: Required, non-empty string.
    - `is_task_done`: Optional, defaults to `false`.
  - **Response:**
    - **201 Created**: Successfully added task.
      ```json
      {
        "idTask": 1,
        "taskDescription": "Description of new task",
        "isTaskDone": false,
        "createdAt": "creation_date",
        "updatedAt": "update_date"
      }
      ```
    - **401 Unauthorized**: Missing or invalid `Authorization` header.
    - **422 Unprocessable Entity**: Errors in request body format.

- **GET** `/task-lists/:listId/tasks/:taskId`

  - **Authenticated**
  - Retrieves details of a specific task within a task list.
  - **Headers:**
    - `Authorization`: `TOKEN`
  - **Response:**
    - **200 OK**: Returns task details.
      ```json
      {
        "idTask": "task_id",
        "idTaskList": "list_id",
        "taskDescription": "Task description",
        "isTaskDone": true,
        "createdAt": "creation_date",
        "updatedAt": "update_date"
      }
      ```
    - **401 Unauthorized**: Missing or invalid `Authorization` header.
    - **404 Not Found**: Task not found.

- **PUT** `/task-lists/:listId/tasks/:taskId`

  - **Authenticated**
  - Updates a specific task within a task list.
  - **Request Body:**
    ```json
    {
      "task_description": "New task description",
      "is_task_done": true // Optional default: false
    }
    ```
  - **Rules:**
    - `task_description`: Required, non-empty string.
    - `is_task_done`: Optional, defaults to `false`.
  - **Response:**
    - **200 OK**: Successfully updated task.
      ```json
      {
        "idTask": 1,
        "taskDescription": "Updated task description",
        "isTaskDone": true,
        "createdAt": "creation_date",
        "updatedAt": "update_date"
      }
      ```
    - **401 Unauthorized**: Missing or invalid `Authorization` header.
    - **404 Not Found**: Task not found.
    - **422 Unprocessable Entity**: Errors in request body format.

- **DELETE** `/task-lists/:listId/tasks/:taskId`
  - **Authenticated**
  - Deletes a specific task from a task list.
  - **Headers:**
    - `Authorization`: `TOKEN`
  - **Response:**
    - **204 No Content**: Successfully deleted task.
    - **401 Unauthorized**: Missing or invalid `Authorization` header.
    - **404 Not Found**: Task not found.

### Status - Observations

- Each task has a completion status: "completed" or "pending."
- The API should automatically calculate the completion percentage for tasks within a list using the formula `(completed tasks / total tasks) * 100`.
- Upon successful **POST** requests, the new percentage is calculated automatically.
- Similarly, for **PUT** requests, if `is_task_done` is updated, the new percentage is recalculated automatically.

## Tags

Users can create, delete, read, and modify tags to classify their task lists. A task list may have no tag, but if it has one, it is limited to only one. When modifying a tag, all associated task lists must be updated.

### Endpoints

- **POST** `/tags`

  - **Authenticated**
  - Creates a new tag.
  - **Request Body:**
    ```json
    {
      "tag_name": "Tag Name"
    }
    ```
  - **Rules:**
    - `tag_name`: Required, non-empty string.
  - **Response:**
    - **201 Created**: Successfully created tag.
      ```json
      {
        "idTag": 1,
        "tagName": "Tag Name",
        "createdAt": "creation_date",
        "updatedAt": "update_date"
      }
      ```
    - **401 Unauthorized**: Missing or invalid `Authorization` header.
    - **422 Unprocessable Entity**: Errors in request body format.

- **GET** `/tags`

  - **Authenticated**
  - Lists all tags for the user.
  - **Headers:**
    - `Authorization`: `TOKEN`
  - **Response:**
    - **200 OK**: Returns a list of tags.
      ```json
      {
        "tags": [
          {
            "idTag": 1,
            "tagName": "Tag Name 1",
            "createdAt": "creation_date",
            "updatedAt": "update_date"
          },
          {
            "idTag": 2,
            "tagName": "Tag Name 2",
            "createdAt": "creation_date",
            "updatedAt": "update_date"
          }
        ]
      }
      ```
    - **401 Unauthorized**: Missing or invalid `Authorization` header.
    - **204 No Content**: If no tags are found.
      ```json
      {
        "tags": []
      }
      ```

- **GET** `/tags/:tagId`

  - **Authenticated**
  - Retrieves details of a specific tag.
  - **Headers:**
    - `Authorization`: `TOKEN`
  - **Response:**
    - **200 OK**: Returns tag details.
      ```json
      {
        "idTag": 1,
        "tagName": "Tag Name",
        "createdAt": "creation_date",
        "updatedAt": "update_date"
      }
      ```
    - **401 Unauthorized**: Missing or invalid `Authorization` header.
    - **404 Not Found**: Tag not found.

- **PUT** `/tags/:tagId`

  - **Authenticated**
  - Updates the name of a tag (reflecting changes in all associated lists).
  - **Request Body:**
    ```json
    {
      "tag_name": "New Tag Name"
    }
    ```
  - **Response:**
    - **200 OK**: Successfully updated tag.
      ```json
      {
        "idTag": 1,
        "tagName": "New Tag Name",
        "createdAt": "creation_date",
        "updatedAt": "update_date"
      }
      ```
    - **401 Unauthorized**: Missing or invalid `Authorization` header.
    - **404 Not Found**: Tag not found.
    - **422 Unprocessable Entity**: Errors in request body format.

- **DELETE** `/tags/:tagId`
  - **Authenticated**
  - Deletes a tag (removing associations with all lists using it).
  - **Headers:**
    - `Authorization`: `TOKEN`
  - **Response:**
    - **204 No Content**: Successfully deleted tag.
    - **401 Unauthorized**: Missing or invalid `Authorization` header.
    - **404 Not Found**: Tag not found.
