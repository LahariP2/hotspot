// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "7e684aa367789cdc14efff20dac081c0"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Event.self)
  }
}