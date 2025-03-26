class AddParentIdToTodos < ActiveRecord::Migration[8.0]
  def change
    add_column :todos, :parent_id, :integer
  end
end
