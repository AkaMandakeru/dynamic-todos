require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      todo = build(:todo)
      expect(todo).to be_valid
    end

    it 'is not valid without a title' do
      todo = build(:todo, title: nil)
      expect(todo).not_to be_valid
    end
  end

  describe 'associations' do
    it 'can have a parent todo' do
      parent = create(:todo)
      child = create(:todo, parent_id: parent.id)
      expect(child.parent).to eq(parent)
    end

    it 'can have multiple subtasks' do
      parent = create(:todo, :with_subtasks)
      expect(parent.subtasks.count).to eq(3)
    end

    it 'destroys dependent subtasks when parent is destroyed' do
      parent = create(:todo, :with_subtasks)
      expect { parent.destroy }.to change { Todo.count }.by(-4) # parent + 3 subtasks
    end
  end

  describe 'scopes' do
    before do
      create_list(:todo, 3)
      create_list(:todo, 2, :completed)
      parent = create(:todo)
      create_list(:todo, 2, parent_id: parent.id)
    end

    it 'returns only root tasks with root_tasks scope' do
      expect(Todo.root_tasks.count).to eq(6) # 3 incomplete + 2 complete + 1 parent
    end

    it 'returns only pending tasks with pending scope' do
      expect(Todo.pending.count).to eq(6) # 3 root + 1 parent + 2 subtasks
    end

    it 'returns only completed tasks with completed scope' do
      expect(Todo.completed.count).to eq(2)
    end
  end
end
