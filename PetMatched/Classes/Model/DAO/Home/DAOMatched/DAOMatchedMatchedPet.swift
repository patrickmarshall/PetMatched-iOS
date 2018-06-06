//
//  DAOMatchedMatchedPet.swift
//
//  Created by Patrick Marshall on 5/8/18
//  Copyright (c) Patrick Marshall. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class DAOMatchedMatchedPet: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let matchedStatus = "matched_status"
    static let petSex = "pet_sex"
    static let variant = "variant"
    static let size = "size"
    static let breedCert = "breed_cert"
    static let petDesc = "pet_desc"
    static let petDob = "pet_dob"
    static let userData = "user_data"
    static let id = "id"
    static let breedName = "breed_name"
    static let furcolor = "furcolor"
    static let vaccines = "vaccines"
    static let weight = "weight"
    static let petPhoto = "pet_photo"
    static let petName = "pet_name"
    }

  // MARK: Properties
  public var matchedStatus: DAOMatchedMatchedStatus?
  public var petSex: String?
  public var variant: String?
  public var size: String?
  public var breedCert: String?
  public var petDesc: String?
  public var petDob: String?
  public var userData: DAOMatchedUserData?
  public var id: Int?
  public var breedName: String?
  public var furcolor: String?
  public var vaccines: [DAOMatchedVaccines]?
  public var weight: String?
  public var petPhoto: String?
  public var petName: String?

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
    matchedStatus = DAOMatchedMatchedStatus(json: json[SerializationKeys.matchedStatus])
    petSex = json[SerializationKeys.petSex].string
    variant = json[SerializationKeys.variant].string
    size = json[SerializationKeys.size].string
    breedCert = json[SerializationKeys.breedCert].string
    petDesc = json[SerializationKeys.petDesc].string
    petDob = json[SerializationKeys.petDob].string
    userData = DAOMatchedUserData(json: json[SerializationKeys.userData])
    id = json[SerializationKeys.id].int
    breedName = json[SerializationKeys.breedName].string
    furcolor = json[SerializationKeys.furcolor].string
    if let items = json[SerializationKeys.vaccines].array { vaccines = items.map { DAOMatchedVaccines(json: $0) } }
    weight = json[SerializationKeys.weight].string
    petPhoto = json[SerializationKeys.petPhoto].string
    petName = json[SerializationKeys.petName].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = matchedStatus { dictionary[SerializationKeys.matchedStatus] = value.dictionaryRepresentation() }
    if let value = petSex { dictionary[SerializationKeys.petSex] = value }
    if let value = variant { dictionary[SerializationKeys.variant] = value }
    if let value = size { dictionary[SerializationKeys.size] = value }
    if let value = breedCert { dictionary[SerializationKeys.breedCert] = value }
    if let value = petDesc { dictionary[SerializationKeys.petDesc] = value }
    if let value = petDob { dictionary[SerializationKeys.petDob] = value }
    if let value = userData { dictionary[SerializationKeys.userData] = value.dictionaryRepresentation() }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = breedName { dictionary[SerializationKeys.breedName] = value }
    if let value = furcolor { dictionary[SerializationKeys.furcolor] = value }
    if let value = vaccines { dictionary[SerializationKeys.vaccines] = value.map { $0.dictionaryRepresentation() } }
    if let value = weight { dictionary[SerializationKeys.weight] = value }
    if let value = petPhoto { dictionary[SerializationKeys.petPhoto] = value }
    if let value = petName { dictionary[SerializationKeys.petName] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.matchedStatus = aDecoder.decodeObject(forKey: SerializationKeys.matchedStatus) as? DAOMatchedMatchedStatus
    self.petSex = aDecoder.decodeObject(forKey: SerializationKeys.petSex) as? String
    self.variant = aDecoder.decodeObject(forKey: SerializationKeys.variant) as? String
    self.size = aDecoder.decodeObject(forKey: SerializationKeys.size) as? String
    self.breedCert = aDecoder.decodeObject(forKey: SerializationKeys.breedCert) as? String
    self.petDesc = aDecoder.decodeObject(forKey: SerializationKeys.petDesc) as? String
    self.petDob = aDecoder.decodeObject(forKey: SerializationKeys.petDob) as? String
    self.userData = aDecoder.decodeObject(forKey: SerializationKeys.userData) as? DAOMatchedUserData
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.breedName = aDecoder.decodeObject(forKey: SerializationKeys.breedName) as? String
    self.furcolor = aDecoder.decodeObject(forKey: SerializationKeys.furcolor) as? String
    self.vaccines = aDecoder.decodeObject(forKey: SerializationKeys.vaccines) as? [DAOMatchedVaccines]
    self.weight = aDecoder.decodeObject(forKey: SerializationKeys.weight) as? String
    self.petPhoto = aDecoder.decodeObject(forKey: SerializationKeys.petPhoto) as? String
    self.petName = aDecoder.decodeObject(forKey: SerializationKeys.petName) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(matchedStatus, forKey: SerializationKeys.matchedStatus)
    aCoder.encode(petSex, forKey: SerializationKeys.petSex)
    aCoder.encode(variant, forKey: SerializationKeys.variant)
    aCoder.encode(size, forKey: SerializationKeys.size)
    aCoder.encode(breedCert, forKey: SerializationKeys.breedCert)
    aCoder.encode(petDesc, forKey: SerializationKeys.petDesc)
    aCoder.encode(petDob, forKey: SerializationKeys.petDob)
    aCoder.encode(userData, forKey: SerializationKeys.userData)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(breedName, forKey: SerializationKeys.breedName)
    aCoder.encode(furcolor, forKey: SerializationKeys.furcolor)
    aCoder.encode(vaccines, forKey: SerializationKeys.vaccines)
    aCoder.encode(weight, forKey: SerializationKeys.weight)
    aCoder.encode(petPhoto, forKey: SerializationKeys.petPhoto)
    aCoder.encode(petName, forKey: SerializationKeys.petName)
  }

}
