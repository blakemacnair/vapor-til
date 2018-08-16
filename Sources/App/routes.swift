import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // POST new Acronym
    router.post("api", "acronyms") { req -> Future<Acronym> in
        return try req.content.decode(Acronym.self)
            .flatMap(to: Acronym.self) { acronym in
                return acronym.save(on: req)
        }
    }

    // GET all Acronyms
    router.get("api", "acronyms") { req -> Future<[Acronym]> in
        return Acronym.query(on: req).all()
    }

    // GET a single Acronym by id
    router.get("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in
        return try req.parameters.next(Acronym.self)
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
}
