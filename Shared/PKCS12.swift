//
//  PKCS12.swift
//  Pusher
//
//  Created by Rajesh Budhiraja on 07/08/21.
//

import Foundation

class PKCS12 {
    let label: String?
    let keyID: NSData?
    let trust: SecTrust?
    let certChain: [SecTrust]?
    let identity: SecIdentity?

    /// Creates a PKCS12 instance from a piece of data.
    /// - Parameters:
    ///   - pkcs12Data:
    ///   - password:
    public init(pkcs12Data: Data, password: String) {
        let importPasswordOption: NSDictionary
          = [kSecImportExportPassphrase as NSString: password]
        var items: CFArray?
        let secError: OSStatus
          = SecPKCS12Import(pkcs12Data as NSData,
                            importPasswordOption, &items)
        guard secError == errSecSuccess else {
            if secError == errSecAuthFailed {
                NSLog("Incorrect password?")

            }
            fatalError("Error trying to import PKCS12 data")
        }
        guard let theItemsCFArray = items else { fatalError() }
        let theItemsNSArray: NSArray = theItemsCFArray as NSArray
        guard let dictArray
          = theItemsNSArray as? [[String: AnyObject]] else {
            fatalError()
          }
        func f<T>(key: CFString) -> T? {
            for dict in dictArray {
                if let value = dict[key as String] as? T {
                    return value
                }
              }
            return nil
        }
        self.label = f(key: kSecImportItemLabel)
        self.keyID = f(key: kSecImportItemKeyID)
        self.trust = f(key: kSecImportItemTrust)
        self.certChain = f(key: kSecImportItemCertChain)
        self.identity = f(key: kSecImportItemIdentity)

    }
}
