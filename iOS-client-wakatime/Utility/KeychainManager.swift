//
//  KeychainManager.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 10/11/18.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

class KeychainManager {
    
    func deleteUserSecretAPIkeyFromKeychain() {
        do {
            let userSecretAPIKeyItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                            accessGroup: KeychainConfiguration.accessGroup)
            try userSecretAPIKeyItem.deleteItem()
            log.debug("Deleting keychain item from query is successful")
        }
        catch {
            log.error("Error deleting keychain item from query - \(error)")
            fatalError(error as! String)
        }
    }
    
    func readUserSecretAPIkeyFromKeychain() -> String {
        var userSecretAPIkey: String
        do {
            let userSecretAPIkeyItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup)
            userSecretAPIkey = try userSecretAPIkeyItem.readPassword()
        }
        catch {
            fatalError("Error reading secret API key from keychain - \(error)")
        }
        
        return userSecretAPIkey
    }
    
    func createAuthorizationHeadersForRequest(userApiKey: String?) -> [String: String] {
        guard let apiKey = userApiKey else {
            let userSecretAPIkeyUsingEncoding = self.readUserSecretAPIkeyFromKeychain().data(using: String.Encoding.utf8)!
            let userSecretAPIkeyBase64Encoded = userSecretAPIkeyUsingEncoding.base64EncodedString(options: [])
            let header = ["Authorization" : "Basic \(userSecretAPIkeyBase64Encoded)"]
            return header
        }
        let userSecretAPIkeyUsingEncoding = apiKey.data(using: String.Encoding.utf8)!
        let userSecretAPIkeyBase64Encoded = userSecretAPIkeyUsingEncoding.base64EncodedString(options: [])
        let headers = ["Authorization" : "Basic \(userSecretAPIkeyBase64Encoded)"]
        return headers
    }
}
