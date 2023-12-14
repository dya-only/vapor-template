import Fluent
import Vapor

struct UserController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let users = routes.grouped("users")
    users.get(use: index)
    users.post(use: create)
    users.group(":userId") { user in
      user.get(use: find)
      user.patch(use: update)
      user.delete(use: delete)
    }
  }
  
  func index(req: Request) async throws -> [UserResponse] {
    try await UserResponse.query(on: req.db).all()
  }
  
  func find(req: Request) async throws -> UserResponse {
    guard let user = try await UserResponse.find(req.parameters.get("userId"), on: req.db) else {
      throw Abort(.notFound)
    }
    
    return user
  }
  
  func create(req: Request) async throws -> UserResponse {
    let user = try req.content.decode(UserRequest.self)
    
    let filename = UUID().uuidString + "-" + user.image.filename
    let imagePath = URL(fileURLWithPath: req.application.directory.publicDirectory.appending("/images/users/\(filename)"))
    try? Data(user.image.data.readableBytesView).write(to:imagePath)
    
    var createUser: UserResponse = UserResponse()
    createUser.id = UUID()
    createUser.email = user.email
    createUser.password = try Bcrypt.hash("vapor")
    createUser.image = filename
    
    try await createUser.save(on: req.db)
    return createUser
  }
  
  func update(req: Request) throws -> EventLoopFuture<UserResponse> {
    let exist = try req.content.decode(UserRequest.self)
    
    return UserResponse.find(req.parameters.get("userId"), on: req.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { item in
        if exist.email != "" { item.email = exist.email }
        if exist.password != "" { item.password = exist.password }
        
        return exist.update(on: req.db).map { return item }
      }
  }
  
  func delete(req: Request) async throws -> HTTPStatus {
    guard let user = try await UserResponse.find(req.parameters.get("userId"), on: req.db) else {
      throw Abort(.notFound)
    }
    
    try await user.delete(on: req.db)
    return .noContent
  }
}
