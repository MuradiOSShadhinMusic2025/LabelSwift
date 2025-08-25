//
//  AESDecryptor.swift
//  Shadhin_shorts_Test
//
//  Created by Shadhin Music on 16/4/25.
//


import UIKit
import CommonCrypto

class AESDecryptor {
    
    static let secretKey = "asdfghjklzxcvbnmqwertyuiop123456"
    
    static func decryptString(_ encryptedText: String, secretKey: String = AESDecryptor.secretKey) -> String? {
        guard let lastColonRange = encryptedText.range(of: ":", options: .backwards) else {
            print("Invalid format. Expected format: encryptedData:iv")
            return nil
        }

        let encryptedDataBase64 = String(encryptedText[..<lastColonRange.lowerBound])
        let ivBase64 = String(encryptedText[lastColonRange.upperBound...])

        guard
            let encryptedData = Data(base64Encoded: encryptedDataBase64),
            let ivData = Data(base64Encoded: ivBase64),
            let keyData = secretKey.data(using: .utf8)
        else {
            print("Base64 decode failed.")
            return nil
        }

//        print("Encrypted Data: \(encryptedDataBase64)")
//        print("IV Data: \(ivBase64)")

        let decrypted = decryptAES(data: encryptedData, keyData: keyData, ivData: ivData)
        return decrypted.flatMap { String(data: $0, encoding: .utf8) }
    }

    
    private static func decryptAES(data: Data, keyData: Data, ivData: Data) -> Data? {
        let keyLength = kCCKeySizeAES256
        var decryptedBytes = [UInt8](repeating: 0, count: data.count + kCCBlockSizeAES128)
        var numBytesDecrypted = 0

        let cryptStatus = data.withUnsafeBytes { dataBytes in
            keyData.withUnsafeBytes { keyBytes in
                ivData.withUnsafeBytes { ivBytes in
                    CCCrypt(
                        CCOperation(kCCDecrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress, keyLength,
                        ivBytes.baseAddress,
                        dataBytes.baseAddress, data.count,
                        &decryptedBytes, decryptedBytes.count,
                        &numBytesDecrypted
                    )
                }
            }
        }

        if cryptStatus == kCCSuccess {
            return Data(bytes: decryptedBytes, count: numBytesDecrypted)
        } else {
            print("Decryption failed with status: \(cryptStatus)")
            return nil
        }
    }
}
