import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // GET a sorted list of Acronyms
    router.get("api", "acronyms", "sorted") { req -> Future<[Acronym]> in
        // TODO: Change this by making "sorted" a query parameter and fold this into the base GET request
        return Acronym.query(on: req)
            .sort(\.short, .ascending)
            .all()
    }

    // PUT update a single acronym
    router.put("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in
        return try flatMap(to: Acronym.self,
                           req.parameters.next(Acronym.self),
                           req.content.decode(Acronym.self)) { (acronym, updatedAcronym) in
                            acronym.short = updatedAcronym.short
                            acronym.long = updatedAcronym.long

                            return acronym.save(on: req)
        }
    }

    // DELETE a single Acronym by id
    router.delete("api", "acronyms", Acronym.parameter) { req -> Future<HTTPStatus> in
        return try req.parameters.next(Acronym.self)
            .delete(on: req)
            .transform(to: HTTPStatus.noContent)
    }

    let acronymsController = AcronymsController()
    try router.register(collection: acronymsController)
}
