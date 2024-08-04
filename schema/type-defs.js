const typeDefs = `#graphql
  type User {
    id: ID!
    name: String!
    age: Int!
    nationality: Nationality!
    username: String!
    friends: [User]
    favoriteMovies: [Movie]
  }

  type Movie {
    id: ID!
    name: String!
    yearOfPublication: Int!
    isInTeather: Boolean!
  }

  type Query {
    users: [User!]!
    user(id: ID!): User!
    movies: [Movie!]!
    movie(name: String!): Movie!
  }

  type Mutation {
    createUser(input: createUserInput!): User!
    updateUserName(input: updateUserNameInput): User
    deleteUser(input: deleteUserInput): User
  }

  input deleteUserInput {
    id: ID!
  }

  input updateUserNameInput {
    id: ID!
    userName: String!
  }

  input createUserInput {
    name: String!
    age: Int = 18
    nationality: Nationality = England
    username: String!
  }

  enum Nationality {
    England
    USA
    Canada
    Germany
    Spain
    Italy
    France
    Japan
    Russia
    Mexico
  }
`;

export default typeDefs 