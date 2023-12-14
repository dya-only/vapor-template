import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
  // uncomment to serve files from /Public folder
   app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
  
  var tlsConfig = TLSConfiguration.makeClientConfiguration()
  tlsConfig.certificateVerification = .none
  
  app.databases.use(DatabaseConfigurationFactory.mysql(
    hostname: Environment.get("DATABASE_HOST") ?? "db",
    port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
    username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
    password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
    database: Environment.get("DATABASE_NAME") ?? "vapor",
    tlsConfiguration: tlsConfig
  ), as: .mysql)
  
  app.migrations.add(CreateUser())
  
  // register routes
  try routes(app)
}
