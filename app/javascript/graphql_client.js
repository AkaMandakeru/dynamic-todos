// Simple GraphQL client for the Dynamic Todo app - Vanilla JS version

const GRAPHQL_ENDPOINT = '/graphql';

// Core GraphQL query function
async function queryGraphQL(queryString, variables = {}) {
  const response = await fetch(GRAPHQL_ENDPOINT, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      query: queryString,
      variables: variables
    })
  });

  return response.json();
}

// Query functions
async function getAllTodos() {
  return queryGraphQL(`
    query {
      todos {
        id
        title
        completed
        parentId
      }
    }
  `);
}

async function getRootTodos() {
  return queryGraphQL(`
    query {
      rootTodos {
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
  `);
}

async function getTodoById(id) {
  return queryGraphQL(`
    query($id: ID!) {
      todo(id: $id) {
        id
        title
        completed
        parentId
        subtasks {
          id
          title
          completed
        }
      }
    }
  `, { id });
}

async function getFilteredTodos(filter) {
  return queryGraphQL(`
    query($filter: String) {
      filteredTodos(filter: $filter) {
        id
        title
        completed
        subtasks {
          id
          title
        }
      }
    }
  `, { filter });
}

async function getSubtasks(parentId) {
  return queryGraphQL(`
    query($parentId: ID!) {
      subtasks(parentId: $parentId) {
        id
        title
        completed
      }
    }
  `, { parentId });
}

// Mutation functions
async function createTodo(title, completed = false) {
  return queryGraphQL(`
    mutation($input: CreateTodoInput!) {
      createTodo(input: $input) {
        todo {
          id
          title
          completed
        }
        errors
      }
    }
  `, {
    input: {
      input: {
        title,
        completed
      }
    }
  });
}

async function createSubtask(parentId, title) {
  return queryGraphQL(`
    mutation($input: CreateSubtaskInput!) {
      createSubtask(input: $input) {
        subtask {
          id
          title
          completed
        }
        errors
      }
    }
  `, {
    input: {
      parentId,
      title
    }
  });
}

async function updateTodo(id, attributes) {
  return queryGraphQL(`
    mutation($input: UpdateTodoInput!) {
      updateTodo(input: $input) {
        todo {
          id
          title
          completed
        }
        errors
      }
    }
  `, {
    input: {
      id,
      ...attributes
    }
  });
}

async function deleteTodo(id) {
  return queryGraphQL(`
    mutation($input: DeleteTodoInput!) {
      deleteTodo(input: $input) {
        id
        errors
      }
    }
  `, {
    input: {
      id
    }
  });
}

// Helper function to display results
function displayResults(elementId, data) {
  const element = document.getElementById(elementId);
  if (element) {
    element.innerHTML = `<pre>${JSON.stringify(data, null, 2)}</pre>`;
  }
}

// Event handlers
document.addEventListener('DOMContentLoaded', () => {
  // Query event listeners
  document.getElementById('getRootTodos')?.addEventListener('click', async () => {
    const result = await getRootTodos();
    displayResults('queryResults', result.data.rootTodos);
  });

  document.getElementById('getCompletedTodos')?.addEventListener('click', async () => {
    const result = await getFilteredTodos('completed');
    displayResults('queryResults', result.data.filteredTodos);
  });

  // Mutation event listeners
  document.getElementById('createTodo')?.addEventListener('click', async () => {
    const titleInput = document.getElementById('newTodoTitle');
    const title = titleInput.value.trim();

    if (title) {
      const result = await createTodo(title);
      displayResults('mutationResults', result.data.createTodo);
      titleInput.value = '';
    }
  });

  document.getElementById('createSubtask')?.addEventListener('click', async () => {
    const parentIdInput = document.getElementById('parentId');
    const titleInput = document.getElementById('subtaskTitle');
    const parentId = parentIdInput.value.trim();
    const title = titleInput.value.trim();

    if (parentId && title) {
      const result = await createSubtask(parentId, title);
      displayResults('mutationResults', result.data.createSubtask);
      titleInput.value = '';
    }
  });

  document.getElementById('updateTodo')?.addEventListener('click', async () => {
    const idInput = document.getElementById('updateTodoId');
    const titleInput = document.getElementById('updateTodoTitle');
    const id = idInput.value.trim();
    const title = titleInput.value.trim();

    if (id && title) {
      const result = await updateTodo(id, { title });
      displayResults('mutationResults', result.data.updateTodo);
      titleInput.value = '';
    }
  });

  document.getElementById('completeTodo')?.addEventListener('click', async () => {
    const idInput = document.getElementById('completeTodoId');
    const id = idInput.value.trim();

    if (id) {
      const result = await updateTodo(id, { completed: true });
      displayResults('mutationResults', result.data.updateTodo);
      idInput.value = '';
    }
  });

  document.getElementById('deleteTodo')?.addEventListener('click', async () => {
    const idInput = document.getElementById('deleteTodoId');
    const id = idInput.value.trim();

    if (id) {
      const result = await deleteTodo(id);
      displayResults('mutationResults', result.data.deleteTodo);
      idInput.value = '';
    }
  });
});
