import Vapor
import Fluent

struct AcronymsController: RouteCollection {

    func boot(router: Router) throws {
        let acronymsRoutes = router.grouped("api", "acronyms")

        acronymsRoutes.get(use: getAllHandler)
        acronymsRoutes.get(Acronym.parameter, use: getSingleHandler)
        acronymsRoutes.get("search", use: getSearchHandler)
        acronymsRoutes.get("first", use: getFirstHandler)
        acronymsRoutes.get("sorted", use: getSortedHandler)

        acronymsRoutes.post(use: postHandler)

        acronymsRoutes.put(Acronym.parameter, use: putHandler)
    }

    // GET a list of all acronyms
    func getAllHandler(_ req: Request) throws -> Future<[Acronym]> {
        return Acronym.query(on: req).all()
    }

    // GET a single Acronym by id
    func getSingleHandler(_ req: Request) throws -> Future<Acronym> {
        return try req.parameters.next(Acronym.self)
    }

    // GET a list of Acronyms by search parameter
    func getSearchHandler(_ req: Request) throws -> Future<[Acronym]> {
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }

        return Acronym.query(on: req).group(.or) { or in
            or.filter(\.short == searchTerm)
            or.filter(\.long == searchTerm)
            }.all()
    }

    // GET the first listed Acronym by id
    func getFirstHandler(_ req: Request) throws -> Future<Acronym> {
        // TODO: Make this searchable
        return Acronym.query(on: req)
            .first()
            .map(to: Acronym.self, { acronym -> Acronym in
                guard let acronym = acronym else {
                    throw Abort(.notFound)
                }

                return acronym
            })
    }

    // GET a sorted list of Acronyms
    func getSortedHandler(_ req: Request) throws -> Future<[Acronym]> {
        // TODO: Change this by making "sorted" a query parameter and fold this into the base GET request
        return Acronym.query(on: req)
            .sort(\.short, .ascending)
            .all()
    }

    // POST new Acronym
    func postHandler(_ req: Request) throws -> Future<Acronym> {
        return try req.content.decode(Acronym.self)
            .flatMap(to: Acronym.self) { acronym in
                return acronym.save(on: req)
        }
    }

    // PUT update a single acronym
    func putHandler(_ req: Request) throws -> Future<Acronym> {
        return try flatMap(to: Acronym.self,
                           req.parameters.next(Acronym.self),
                           req.content.decode(Acronym.self)) { (acronym, updatedAcronym) in
                            acronym.short = updatedAcronym.short
                            acronym.long = updatedAcronym.long

                            return acronym.save(on: req)
        }
    }
}
