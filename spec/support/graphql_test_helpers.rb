module GraphQLTestHelpers
  # Execute a GraphQL query
  def execute_query(query, variables: {}, context: {})
    DynamicTodoSchema.execute(
      query,
      variables: variables.deep_stringify_keys,
      context: context
    )
  end

  # Helper for executing mutations with proper Relay-style input format
  def execute_relay_mutation(mutation, input_variables, context: {})
    # For Relay-style mutations, input is already properly formatted
    execute_query(
      mutation,
      variables: input_variables,
      context: context
    )
  end
  
  # Parse GraphQL response and handle errors
  def parse_graphql_response(response)
    if response["errors"]
      raise "GraphQL Error: #{response["errors"].map { |e| e["message"] }.join(", ")}"
    end
    response["data"]
  end
end
