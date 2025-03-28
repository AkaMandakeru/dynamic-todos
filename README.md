# Dynamic Todo Application

A modern, feature-rich todo application built with Ruby on Rails and GraphQL. This application allows users to manage todos with subtasks, filter by status, and interact with the data through both a traditional REST API and a GraphQL API.

## Features

### Todo Management
- **Create**: Add new todos with titles
- **Read**: View all todos with filtering options (All, Pending, Completed)
- **Update**: Mark todos as completed or update their titles
- **Delete**: Remove unwanted todos

### Subtasks
- Create nested subtasks for any todo item
- Subtasks inherit the same CRUD functionality as parent todos
- Parent-child relationship maintained through the database

### GraphQL API
- Full GraphQL implementation with Relay-style mutations
- Interactive GraphiQL explorer available at `/graphiql`
- Supported operations:
  - Query todos and subtasks
  - Create, update, and delete todos
  - Create subtasks

## Technology Stack

- **Ruby version**: Ruby 3.2.3 with Rails 8.0.2
- **Database**: PostgreSQL
- **Frontend**: Tailwind CSS, Stimulus.js, Turbo
- **API**: REST and GraphQL (with Relay-style mutations)
- **Testing**: RSpec, Factory Bot

## GraphQL Implementation

The application uses GraphQL with Relay-style mutations:

- Input types follow naming convention like `CreateTodoInput`
- Mutations require nested input structure: `{ input: { input: { actual data } } }`
- All mutations (createTodo, updateTodo, deleteTodo, createSubtask) use Relay-style format
- Base mutation class is `GraphQL::Schema::RelayClassicMutation`

## Development Setup

### Prerequisites
- Ruby 3.2.3
- PostgreSQL
- Node.js and Yarn

### Installation
1. Clone the repository
2. Install dependencies:
   ```
   bundle install
   ```
3. Setup the database:
   ```
   rails db:create db:migrate db:seed
   ```
4. Start the server:
   ```
   rails server
   ```
5. Visit `http://localhost:3000` in your browser

## Testing

Run the test suite with:
```
bundle exec rspec
```

## Deployment

This application is deployed on Heroku. The production version can be accessed at:
[https://dynamic-todos-993640c2aaf6.herokuapp.com](https://dynamic-todos-993640c2aaf6.herokuapp.com)

### Deployment Process
1. Ensure your changes are committed to Git
2. Deploy to Heroku:
   ```
   git push heroku main
   ```
3. Run database migrations if needed:
   ```
   heroku run rails db:migrate
   ```

## GraphQL API Usage

### Example Queries

Fetch all todos:
```graphql
query {
  todos {
    id
    title
    completed
    subtasks {
      id
      title
      completed
    }
  }
}
```

### Example Mutations

Create a new todo:
```graphql
mutation {
  createTodo(input: {
    input: {
      title: "New Todo"
      completed: false
    }
  }) {
    todo {
      id
      title
      completed
    }
    errors
  }
}
```

Create a subtask:
```graphql
mutation {
  createSubtask(input: {
    input: {
      title: "New Subtask"
      parentId: "1"
    }
  }) {
    todo {
      id
      title
    }
    errors
  }
}
```
