document.addEventListener('DOMContentLoaded', () => {
  // Toggle subtasks visibility
  document.addEventListener('click', (e) => {
    if (e.target.closest('.toggle-subtasks')) {
      const button = e.target.closest('.toggle-subtasks');
      const todoItem = button.closest('[data-todo-id]');
      const subtasksContainer = todoItem.querySelector('.subtasks-container');
      const expandIcon = button.querySelector('.expand-icon');

      subtasksContainer.classList.toggle('hidden');
      expandIcon.textContent = subtasksContainer.classList.contains('hidden') ? '▼' : '▲';
    }
  });

  // Handle subtask form submission
  document.addEventListener('submit', (e) => {
    if (e.target.classList.contains('add-subtask-form')) {
      e.preventDefault();
      const form = e.target;
      const todoId = form.querySelector('[name="parent_id"]').value;
      const titleInput = form.querySelector('[name="title"]');
      const title = titleInput.value.trim();

      if (!title) return;

      fetch(`/api/subtasks/${todoId}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          subtask: {
            title: title
          }
        })
      })
      .then(response => response.json())
      .then(data => {
        const todoItem = form.closest('[data-todo-id]');
        const subtasksList = todoItem.querySelector('.subtasks-list');
        const newSubtask = document.createElement('div');
        newSubtask.className = 'subtask-item';
        newSubtask.innerHTML = `
          <div class="flex items-center gap-2 p-1 border rounded">
            <span>${data.title}</span>
          </div>
        `;
        subtasksList.appendChild(newSubtask);
        titleInput.value = '';
      })
      .catch(error => {
        console.error('Error:', error);
      });
    }
  });
});
