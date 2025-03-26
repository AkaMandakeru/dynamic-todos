require 'rails_helper'

RSpec.describe Mutations::DeleteTodo, type: :graphql do
  let(:mutation) do
    <<~GQL
      mutation DeleteTodo($input: DeleteTodoInput!) {
        deleteTodo(input: $input) {
          id
          errors
        }
      }
    GQL
  end

  describe 'deleting a todo' do
    let!(:todo) { create(:todo, title: 'Todo to delete') }

    it 'deletes a todo with valid id' do
      # Using the Relay-style input structure as shown in the JavaScript client
      input_variables = {
        input: {
          id: todo.id.to_s
        }
      }

      expect {
        result = execute_relay_mutation(mutation, input_variables)
        data = parse_graphql_response(result)

        expect(data['deleteTodo']['id']).to eq(todo.id.to_s)
        expect(data['deleteTodo']['errors']).to be_empty
      }.to change(Todo, :count).by(-1)

      # Verify todo was deleted
      expect(Todo.find_by(id: todo.id)).to be_nil
    end

    it 'deletes a parent todo and all its subtasks' do
      parent = create(:todo, :with_subtasks)
      subtask_count = parent.subtasks.count
      
      input_variables = {
        input: {
          id: parent.id.to_s
        }
      }

      expect {
        result = execute_relay_mutation(mutation, input_variables)
        data = parse_graphql_response(result)

        expect(data['deleteTodo']['id']).to eq(parent.id.to_s)
        expect(data['deleteTodo']['errors']).to be_empty
      }.to change(Todo, :count).by(-(subtask_count + 1))

      # Verify parent and subtasks were deleted
      expect(Todo.find_by(id: parent.id)).to be_nil
      parent.subtasks.each do |subtask|
        expect(Todo.find_by(id: subtask.id)).to be_nil
      end
    end

    it 'returns errors when todo does not exist' do
      input_variables = {
        input: {
          id: 'non-existent-id'
        }
      }

      # For non-existent IDs, we expect an ActiveRecord::RecordNotFound exception
      expect {
        execute_relay_mutation(mutation, input_variables)
      }.to raise_error(ActiveRecord::RecordNotFound, /Couldn't find Todo/)
    end
  end
end
