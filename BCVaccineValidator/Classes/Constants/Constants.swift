//
//  File.swift
//  
//
//  Created by Amir Shayegh on 2021-09-20.
//

import Foundation

struct Constants {
    static let networkTimeout: Double = 5
        
    struct JWKSPublic {
        static let wellKnownJWKS_URLExtension = ".well-known/jwks.json"
    }
    
    struct CVX {
        static let janssen = "212"
    }
    
    struct Directories {
        static let caceDirectoryName: String = "VaccineValidatorCache"
        
        // Will remove this
        struct issuers {
            static var fileName: String {
                return "issuers.json"
                /*
                switch BCVaccineValidator.mode {
                case .Prod:
                    return "issuers.json"
                case .Test, .Dev:
                    return "issuers-test.json"
                }
                */
            }
            static let directoryName = "issuers"
        }
        
        // Will remove this
        struct rules {
            static var fileName: String {
                return "rules.json"
                /*
                switch BCVaccineValidator.mode {
                case .Prod:
                    return "rules.json"
                case .Test:
                    return "rules-test.json"
                case .Dev:
                    return "rules-dev.json"
                }
                */
            }
            static let directoryName = "rules"
        }
    }
    
    struct UserDefaultKeys {
        static let issuersTimeOutKey = "issuersTimeout"
        static let vaccinationRulesTimeOutKey = "vaccinationRulesTimeout"
    }
}
