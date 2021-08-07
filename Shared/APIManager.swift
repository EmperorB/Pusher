//
//  APIManager.swift
//  Pusher
//
//  Created by Rajesh Budhiraja on 07/08/21.
//

import Foundation

public class ApiManager: NSObject, URLSessionDelegate, URLSessionDataDelegate {

    var delegate: APIManagerDelegate?
    var session: URLSession?

    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // `NSURLAuthenticationMethodClientCertificate`
        //  indicates the server requested a client certificate.
        if challenge.protectionSpace.authenticationMethod != NSURLAuthenticationMethodClientCertificate {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        guard let url = self.delegate?.getFilePath(), let password = self.delegate?.getPassword(), let p12Data = try? Data(contentsOf: url) else {
            // Loading of data failed
            return
        }
        let p12Contents = PKCS12(pkcs12Data: p12Data, password: password)
        guard let identity = p12Contents.identity else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        // In my case, and as Apple recommends,
        // we do not pass the certificate chain into
        // the URLCredential used to respond to the challenge.
        let credential = URLCredential(identity: identity,
                                       certificates: nil,
                                       persistence: .none)
        challenge.sender?.use(credential, for: challenge)
        completionHandler(.useCredential, credential)
    }

    public func sendTestNotification() {
        guard let deviceId = self.delegate?.getDeviceId(),
              let payload = self.delegate?.getPayload(),
              let topic = self.delegate?.getTopic(),
              let priority = self.delegate?.getPriority() else {
            return
        }
        let api = "https://api.development.push.apple.com/3/device/\(deviceId)"
        session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: nil)
        guard let url = URL(string: api) else {
            return
        }
        var request = URLRequest(url: url)
        request.setValue(topic, forHTTPHeaderField: "apns-topic")
        request.setValue(priority, forHTTPHeaderField: "apns-priority")
        request.httpMethod = "POST"
        request.httpBody = payload.data(using: .utf8)
        session?.dataTask(with: request).resume()
    }

}

protocol APIManagerDelegate {
    func getFilePath() -> URL?
    func getPassword() -> String
    func getDeviceId() -> String
    func getPayload() -> String
    func getTopic() -> String
    func getPriority() -> String
}
