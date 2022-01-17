//
//  ValidatorConfig.swift
//  BCVaccineValidator
//
//  Created by Mohamed Afsar on 17/01/22.
//

import Foundation

public struct ValidatorConfig {
    static var `default`: ValidatorConfig {
        ValidatorConfig(issuersUrl: "https://smarthealthcard.phsa.ca/v1/trusted/.well-known/issuers.json",
               rulesUrl: "https://smarthealthcard.phsa.ca/v1/covid19proof/.well-known/rules.json")
    }
    
    public var issuersCacheExpiryInMinutes: Double = 6 * 60 // 6 Hours
    public var rulesCacheExpiryInMinutes: Double = 6 * 60 // 6 Hours
    public var resourceBundle: Bundle = .main
    public var enableRemoteRules = true
    public var shouldUpdateWhenOnline = false
    public let issuersUrl: String
    public let rulesUrl: String
    public var issuersFileNameWithExtension = "issuers.json"
    public var rulesFileNameWithExtension = "rules.json"
    
    public init(issuersUrl: String, rulesUrl: String) {
        self.issuersUrl = issuersUrl
        self.rulesUrl = rulesUrl
    }
}

extension ValidatorConfig: CustomStringConvertible {
    public var description: String {
        return """
            enableRemoteRules: \(enableRemoteRules)
            shouldUpdateWhenOnline: \(shouldUpdateWhenOnline)
        """
    }
}
