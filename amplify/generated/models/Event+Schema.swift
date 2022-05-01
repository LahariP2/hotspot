// swiftlint:disable all
import Amplify
import Foundation

extension Event {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case date
    case location
    case details
    case points
    case code
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let event = Event.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Events"
    
    model.fields(
      .id(),
      .field(event.name, is: .required, ofType: .string),
      .field(event.date, is: .required, ofType: .dateTime),
      .field(event.location, is: .required, ofType: .string),
      .field(event.details, is: .optional, ofType: .string),
      .field(event.points, is: .required, ofType: .int),
      .field(event.code, is: .required, ofType: .string),
      .field(event.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(event.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}