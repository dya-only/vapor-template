import Fluent

struct CreateUser: AsyncMigration {
  func prepare(on database: Database) async throws {
    try await database.schema("users")
      .id()
      .field("email", .string, .required)
      .field("password", .string, .required)
      .create()
  }
  
  func revert(on database: Database) async throws {
    try await database.schema("users").delete()
  }
}
