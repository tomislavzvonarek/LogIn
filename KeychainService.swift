//
//  KeychainService.swift
//  Authentication3
//
//  Created by Tomislav Zvonarek on 28.04.2023..
//

import Foundation
import Security

struct KeychainService {
    
    //func takes access token and saves it to keychain
    @discardableResult
    static func saveAccessTokenToKeychain(_ accessToken: String) -> Bool {
        guard let data = accessToken.data(using: .utf8) else {
            return false
        }

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: /*your service*/,
            kSecAttrAccount: "access_token",
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    //func deletes access token from keychain
    @discardableResult
    static func deleteAccessTokenFromKeychain() -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: /*your service*/,
            kSecAttrAccount: "access_token"
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    //func searching for access token in keychain
    static func loadAccessTokenFromKeychain() -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: /*your service*/,
            kSecAttrAccount: "access_token",
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess, let data = item as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}

