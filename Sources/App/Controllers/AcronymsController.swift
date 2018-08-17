import Vapor
import Fluent

struct AcronymsController: RouteCollection {

    func boot(router: Router) throws {
        let acronymsRoutes = router.grouped("api", "acronyms")

        acronymsRoutes.get(use: getAllHandler)
    }

    // GET a list of all acronyms
    func getAllHandler(_ req: Request) throws -> Future<[Acronym]> {
        return Acronym.query(on: req).all()
    }

    // POST new Acronym
    func postHandler(_ req: Request) throws -> Future<Acronym> {
        return try req.content.decode(Acronym.self)
            .flatMap(to: Acronym.self) { acronym in
                return acronym.save(on: req)
        }
    }
}
