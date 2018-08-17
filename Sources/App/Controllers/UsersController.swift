import Vapor

struct UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("api", "users")

        usersRoute.post(User.self, use: postHandler)
    }

    // POST a new user
    func postHandler(_ req: Request, user: User) throws -> Future<User> {
        return user.save(on: req)
    }

}
