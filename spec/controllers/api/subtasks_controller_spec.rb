require 'rails_helper'

RSpec.describe Api::SubtasksController, type: :controller do
  describe "POST #create" do
    let(:parent_todo) { create(:todo) }

    context "with valid parameters" do
      let(:valid_params) { { parent_id: parent_todo.id, subtask: { title: "New Subtask" } } }

      it "creates a new subtask" do
        expect {
          post :create, params: valid_params
        }.to change { parent_todo.subtasks.count }.by(1)
      end

      it "returns a successful JSON response" do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
      end

      it "returns the created subtask data" do
        post :create, params: valid_params
        json_response = JSON.parse(response.body)
        expect(json_response).to include('id', 'title')
        expect(json_response['title']).to eq("New Subtask")
      end

      it "associates the subtask with the parent todo" do
        post :create, params: valid_params
        expect(parent_todo.subtasks.last.title).to eq("New Subtask")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { parent_id: parent_todo.id, subtask: { title: "" } } }

      it "does not create a new subtask" do
        expect {
          post :create, params: invalid_params
        }.not_to change { parent_todo.subtasks.count }
      end

      it "returns an error status" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error details" do
        post :create, params: invalid_params
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('errors')
      end
    end

    context "with non-existent parent" do
      it "raises a record not found error" do
        expect {
          post :create, params: { parent_id: 999999, subtask: { title: "New Subtask" } }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
