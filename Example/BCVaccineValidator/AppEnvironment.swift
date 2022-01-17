//
//  AppEnvironment.swift
//  BCVaccineValidator_Example
//
//  Created by Mohamed Afsar on 17/01/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

internal enum AppEnvironment {
    case dev, test, prod
}

// MARK: IVars
extension AppEnvironment {
    var issuersUrl: String {
        switch self {
        case .dev:
            return "https://phsasmarthealthcard-dev.azurewebsites.net/v1/trusted/.well-known/issuers.json"
        case .test:
            return "https://phsasmarthealthcard-dev.azurewebsites.net/v1/trusted/.well-known/issuers.json"
        case .prod:
            return "https://smarthealthcard.phsa.ca/v1/trusted/.well-known/issuers.json"
        }
    }
    
    var rulesUrl: String {
        switch self {
        case .dev:
            return "https://ds9mwekyyprcy.cloudfront.net/rules.json"
        case .test:
            return "https://phsasmarthealthcard-dev.azurewebsites.net/v1/Covid19Proof/.well-known/rules.json"
        case .prod:
            return "https://smarthealthcard.phsa.ca/v1/covid19proof/.well-known/rules.json"
        }
    }
    
    var issuersCacheExpiryInMinutes: Double {
        switch self {
        case .dev, .test:
            return 1 // 1 Minute
        case .prod:
            return 6 * 60 // 6 Hours
        }
    }
    
    var rulesCacheExpiryInMinutes: Double {
        switch self {
        case .dev, .test:
            return 1 // 1 Minute
        case .prod:
            return 6 * 60 // 6 Hours
        }
    }
    
    var resourceBundle: Bundle { .main }
    
    var enableRemoteRules: Bool { true }
    
    var shouldUpdateWhenOnline: Bool { false }
    
    var issuersFileNameWithExtension: String {
        switch self {
        case .dev, .test:
            return "issuers-test.json"
        case .prod:
            return "issuers.json"
        }
    }
    
    var rulesFileNameWithExtension: String {
        switch self {
        case .dev:
            return "rules-dev.json"
        case .test:
            return "rules-test.json"
        case .prod:
            return "rules.json"
        }
    }
}
