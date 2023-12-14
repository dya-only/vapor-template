import Fluent

struct UpdateUser: AsyncMigration {
  func prepare(on database: Database) async throws {
    try await database.schema("users")
      .id()
      .field("email", .string, .required)
      .field("password", .string, .required)
      .field("image", .string)
      .create()
  }
  
  func revert(on database: Database) async throws {
    try await database.schema("users").delete()
  }
}
