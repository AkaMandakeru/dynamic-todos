module Types
  class TodoInput < Types::BaseInputObject
    argument :title, String, required: true
    argument :completed, Boolean, required: false
    argument :parent_id, ID, required: false
  end
end
