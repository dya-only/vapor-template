import Fluent
import Vapor

struct UserController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let users = routes.grouped("users")
    users.get(use: index)
    users.post(use: create)
    users.group(":userId") { user in
      user.get(use: find)
      user.delete(use: delete)
    }
  }
  
  func index(req: Request) async throws -> [User] {
    try await User.query(on: req.db).all()
  }
  
  func find(req: Request) async throws -> User {
    guard let user = try await User.find(req.parameters.get("userId"), on: req.db) else {
      throw Abort(.notFound)
    }
    
    return user
  }
  
  func create(req: Request) async throws -> User {
    let user = try req.content.decode(User.self)
    
    try await user.save(on: req.db)
    return user
  }
  
  func delete(req: Request) async throws -> HTTPStatus {
    guard let user = try await User.find(req.parameters.get("userId"), on: req.db) else {
      throw Abort(.notFound)
    }
    try await user.delete(on: req.db)
    return .noContent
  }
}
