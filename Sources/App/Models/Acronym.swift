import Vapor
import FluentMySQL

// All Fluent models must conform to Codable
final class Acronym: Codable {
    var id: Int?
    var short: String
    var long: String

    init(short: String, long: String) {
        self.short = short
        self.long = long
    }
}

/*
// Conform to Fluent's Model
extension Acronym: Model {
    // The type of DB to use for this model
    typealias Database = SQLiteDatabase

    // The type of this model's ID
    typealias ID = Int

    // The key path of the model's ID property
    static var idKey: IDKey = \Acronym.id
}
 */

// Equivalent to the above block of commented-out code
extension Acronym: MySQLModel {}

// Conform to Migration to allow simple database migrations
extension Acronym: Migration {}

// Conform to Content - a wrapper around Codable - to allow converting models between various formats
extension Acronym: Content {}
