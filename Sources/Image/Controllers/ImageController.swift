import Fluent
import Vapor

struct ImageController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let files = routes.grouped("images")
    files.group(":imageId") { file in
      file.get(use: find)
    }
  }
  
  func find(req: Request) throws -> String {
    guard let imageId = req.parameters.get("imageId") else {
      throw Abort(.badRequest)
    }
    
    let path = req.application.directory.publicDirectory.appending("/images/users/\(imageId)")
    //    if FileManager.default.fileExists(atPath: path) {
    //      let data = try Data(contentsOf: URL(fileURLWithPath: path))
    //      let response = Response(status: .ok, body: .init(data: data))
    //      response.headers.replaceOrAdd(name: .contentType, value: "image/png")
    //
    //      return req.eventLoop.makeSucceededFuture(response)
    //    }
    //    else {
    //      throw Abort(.notFound)
    guard let imageData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
      throw Abort(.internalServerError)
    }
    
    let base64ImageString = imageData.base64EncodedString()
    return base64ImageString
  }
}
