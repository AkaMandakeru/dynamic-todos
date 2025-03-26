require 'rails_helper'

RSpec.describe Mutations::CreateTodo, type: :graphql do
  let(:mutation) do
    <<~GQL
      mutation CreateTodo($input: CreateTodoInput!) {
        createTodo(input: $input) {
          todo {
            id
            title
            completed
            parentId
          }
          errors
        }
      }
    GQL
  end

  describe 'creating a todo' do
    it 'creates a new todo with valid attributes' do
      # Using the Relay-style input structure with double nesting: { input: { input: { actual data } } }
      input_variables = {
        input: {
          input: {
            title: 'New Todo Item',
            completed: false
          }
        }
      }

      result = execute_relay_mutation(mutation, input_variables)
      data = parse_graphql_response(result)

      expect(data['createTodo']['todo']).to include(
        'title' => 'New Todo Item',
        'completed' => false,
        'parentId' => nil
      )
      expect(data['createTodo']['errors']).to be_empty
      expect(Todo.count).to eq(1)
    end

    it 'returns errors with invalid attributes' do
      input_variables = {
        input: {
          input: {
            title: '', # Invalid: empty title
            completed: false
          }
        }
      }

      result = execute_relay_mutation(mutation, input_variables)
      data = parse_graphql_response(result)

      expect(data['createTodo']['todo']).to be_nil
      expect(data['createTodo']['errors']).not_to be_empty
      expect(Todo.count).to eq(0)
    end

    it 'creates a subtask with valid parent_id' do
      parent = create(:todo)

      input_variables = {
        input: {
          input: {
            title: 'Subtask Item',
            parentId: parent.id
          }
        }
      }

      result = execute_relay_mutation(mutation, input_variables)
      data = parse_graphql_response(result)

      # The parentId field in the GraphQL response is an Integer, not a String
      expect(data['createTodo']['todo']).to include(
        'title' => 'Subtask Item',
        'completed' => false,
        'parentId' => parent.id
      )
      expect(data['createTodo']['errors']).to be_empty
      expect(Todo.count).to eq(2) # parent + new subtask
      expect(parent.subtasks.count).to eq(1)
    end
  end
end
