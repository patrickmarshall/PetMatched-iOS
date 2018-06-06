//
//  DAOHistoryListResponse.swift
//
//  Created by Patrick Marshall on 5/23/18
//  Copyright (c) Patrick Marshall. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class DAOHistoryListResponse: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let fromPhoto = "from_photo"
    static let toPhoto = "to_photo"
    static let score = "score"
    static let matchDate = "match_date"
    static let petFrom = "pet_from"
    static let matchStat = "match_stat"
    static let petTo = "pet_to"
    static let toBreed = "to_breed"
    static let toName = "to_name"
    static let fromName = "from_name"
    static let fromBreed = "from_breed"
  }

  // MARK: Properties
  public var fromPhoto: String?
  public var toPhoto: String?
  public var score: String?
  public var matchDate: String?
  public var petFrom: Int?
  public var matchStat: String?
  public var petTo: Int?
  public var toBreed: String?
  public var toName: String?
  public var fromName: String?
  public var fromBreed: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    fromPhoto = json[SerializationKeys.fromPhoto].string
    toPhoto = json[SerializationKeys.toPhoto].string
    score = json[SerializationKeys.score].string
    matchDate = json[SerializationKeys.matchDate].string
    petFrom = json[SerializationKeys.petFrom].int
    matchStat = json[SerializationKeys.matchStat].string
    petTo = json[SerializationKeys.petTo].int
    toBreed = json[SerializationKeys.toBreed].string
    toName = json[SerializationKeys.toName].string
    fromName = json[SerializationKeys.fromName].string
    fromBreed = json[SerializationKeys.fromBreed].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = fromPhoto { dictionary[SerializationKeys.fromPhoto] = value }
    if let value = toPhoto { dictionary[SerializationKeys.toPhoto] = value }
    if let value = score { dictionary[SerializationKeys.score] = value }
    if let value = matchDate { dictionary[SerializationKeys.matchDate] = value }
    if let value = petFrom { dictionary[SerializationKeys.petFrom] = value }
    if let value = matchStat { dictionary[SerializationKeys.matchStat] = value }
    if let value = petTo { dictionary[SerializationKeys.petTo] = value }
    if let value = toBreed { dictionary[SerializationKeys.toBreed] = value }
    if let value = toName { dictionary[SerializationKeys.toName] = value }
    if let value = fromName { dictionary[SerializationKeys.fromName] = value }
    if let value = fromBreed { dictionary[SerializationKeys.fromBreed] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.fromPhoto = aDecoder.decodeObject(forKey: SerializationKeys.fromPhoto) as? String
    self.toPhoto = aDecoder.decodeObject(forKey: SerializationKeys.toPhoto) as? String
    self.score = aDecoder.decodeObject(forKey: SerializationKeys.score) as? String
    self.matchDate = aDecoder.decodeObject(forKey: SerializationKeys.matchDate) as? String
    self.petFrom = aDecoder.decodeObject(forKey: SerializationKeys.petFrom) as? Int
    self.matchStat = aDecoder.decodeObject(forKey: SerializationKeys.matchStat) as? String
    self.petTo = aDecoder.decodeObject(forKey: SerializationKeys.petTo) as? Int
    self.toBreed = aDecoder.decodeObject(forKey: SerializationKeys.toBreed) as? String
    self.toName = aDecoder.decodeObject(forKey: SerializationKeys.toName) as? String
    self.fromName = aDecoder.decodeObject(forKey: SerializationKeys.fromName) as? String
    self.fromBreed = aDecoder.decodeObject(forKey: SerializationKeys.fromBreed) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(fromPhoto, forKey: SerializationKeys.fromPhoto)
    aCoder.encode(toPhoto, forKey: SerializationKeys.toPhoto)
    aCoder.encode(score, forKey: SerializationKeys.score)
    aCoder.encode(matchDate, forKey: SerializationKeys.matchDate)
    aCoder.encode(petFrom, forKey: SerializationKeys.petFrom)
    aCoder.encode(matchStat, forKey: SerializationKeys.matchStat)
    aCoder.encode(petTo, forKey: SerializationKeys.petTo)
    aCoder.encode(toBreed, forKey: SerializationKeys.toBreed)
    aCoder.encode(toName, forKey: SerializationKeys.toName)
    aCoder.encode(fromName, forKey: SerializationKeys.fromName)
    aCoder.encode(fromBreed, forKey: SerializationKeys.fromBreed)
  }

}
