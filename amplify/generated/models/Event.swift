// swiftlint:disable all
import Amplify
import Foundation

public struct Event: Model {
  public let id: String
  public var name: String
  public var date: Temporal.DateTime
  public var location: String
  public var details: String?
  public var points: Int
  public var code: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String,
      date: Temporal.DateTime,
      location: String,
      details: String? = nil,
      points: Int,
      code: String) {
    self.init(id: id,
      name: name,
      date: date,
      location: location,
      details: details,
      points: points,
      code: code,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String,
      date: Temporal.DateTime,
      location: String,
      details: String? = nil,
      points: Int,
      code: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.date = date
      self.location = location
      self.details = details
      self.points = points
      self.code = code
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}