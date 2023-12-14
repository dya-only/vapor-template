import Fluent
import Vapor

final class UserRequest: Model, Content {
  static let schema = "users"
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: "email")
  var email: String
  
  @Field(key: "password")
  var password: String
  
  @Field(key: "image")
  var image: File
  
  init() { }
  
  init(
    email: String,
    password: String,
    image: File
  ) {
    self.email = email
    self.password = password
    self.image = image
  }
}

final class UserResponse: Model, Content {
  static let schema = "users"
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: "email")
  var email: String
  
  @Field(key: "password")
  var password: String
  
  @Field(key: "image")
  var image: String
  
  init() { }
  
  init(
    id: UUID? = nil,
    email: String,
    password: String,
    image: String
  ) {
    self.id = id
    self.email = email
    self.password = password
    self.image = image
  }
}
