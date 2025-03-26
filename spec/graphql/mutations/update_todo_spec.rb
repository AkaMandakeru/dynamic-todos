require 'rails_helper'

RSpec.describe Mutations::UpdateTodo, type: :graphql do
  let(:mutation) do
    <<~GQL
      mutation UpdateTodo($input: UpdateTodoInput!) {
        updateTodo(input: $input) {
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

  describe 'updating a todo' do
    let!(:todo) { create(:todo, title: 'Original Title', completed: false) }

    it 'updates a todo with valid attributes' do
      # Using the Relay-style input structure as shown in the JavaScript client
      input_variables = {
        input: {
          id: todo.id.to_s,
          title: 'Updated Title',
          completed: true
        }
      }

      result = execute_relay_mutation(mutation, input_variables)
      data = parse_graphql_response(result)

      expect(data['updateTodo']['todo']).to include(
        'title' => 'Updated Title',
        'completed' => true
      )
      expect(data['updateTodo']['errors']).to be_empty

      # Verify database was updated
      todo.reload
      expect(todo.title).to eq('Updated Title')
      expect(todo.completed).to eq(true)
    end

    it 'returns errors when todo does not exist' do
      input_variables = {
        input: {
          id: 'non-existent-id',
          title: 'Updated Title'
        }
      }

      # For non-existent IDs, we expect an ActiveRecord::RecordNotFound exception
      expect {
        execute_relay_mutation(mutation, input_variables)
      }.to raise_error(ActiveRecord::RecordNotFound, /Couldn't find Todo/)
    end

    it 'returns errors with invalid attributes' do
      input_variables = {
        input: {
          id: todo.id.to_s,
          title: '' # Invalid: empty title
        }
      }

      result = execute_relay_mutation(mutation, input_variables)
      data = parse_graphql_response(result)

      expect(data['updateTodo']['todo']).to be_nil
      expect(data['updateTodo']['errors']).not_to be_empty

      # Verify database was not updated
      todo.reload
      expect(todo.title).to eq('Original Title')
    end
  end
end
