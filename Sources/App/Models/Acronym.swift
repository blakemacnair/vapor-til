import Vapor
import FluentSQLite

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

// Conform to Fluent's Model
extension Acronym: Model {
    // The type of DB to use for this model
    typealias Database = SQLiteDatabase

    // The type of this model's ID
    typealias ID = Int

    // The key path of the model's ID property
    static var idKey: IDKey = \Acronym.id
}
