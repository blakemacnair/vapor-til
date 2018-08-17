import Vapor

struct UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("api", "users")

        usersRoute.post(User.self, use: postHandler)

        usersRoute.get(use: getAllHandler)
        usersRoute.get(User.parameter, use: getSingleHandler)
    }

    // POST a new user
    func postHandler(_ req: Request, user: User) throws -> Future<User> {
        return user.save(on: req)
    }

    // GET a full list of users
    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }

    // GET a single user by id
    func getSingleHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
}
