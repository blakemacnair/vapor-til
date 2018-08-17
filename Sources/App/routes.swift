import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Register Acronyms Controller and its routes
    let acronymsController = AcronymsController()
    try router.register(collection: acronymsController)
}
