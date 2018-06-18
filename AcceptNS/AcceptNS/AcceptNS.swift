//
//  AcceptToken.swift
//  AcceptNS
//
//  Created by Piotr Ilski on 18.06.2018.
//  Copyright © 2018 Beachy. All rights reserved.
//

import Foundation
import AcceptSDK

@objc public protocol AcceptNSProtocol {
    func didCallGetToken()
}

@objc open class AcceptNSRequest: NSObject {
    @objc open var cardNumber: String?
    @objc open var expMonth: String?
    @objc open var expYear: String?
    @objc open var cvc: String?
    
    @objc override public init() {
        super.init()
    }
}

@objc public enum AcceptNSEnvironment: UInt {
    case ENV_TEST = 1
    case ENV_LIVE = 2
}

@objc open class AcceptNSConfig: NSObject {
    @objc open var clientName: String?
    @objc open var clientKey: String?
    @objc open let environment: AcceptNSEnvironment
    
    @objc public init(environment: AcceptNSEnvironment) {
        self.environment = environment
        
        super.init()
    }
}

@objc open class AcceptNS: NSObject {
    @objc open static let shared = AcceptNS()
    
    @objc open var delegate: AcceptNSProtocol?
    
    @objc public func getTestToken() -> String {
        return "Have it!";
    }
    
    @objc open func getToken(
        config: AcceptNSConfig,
        payload: AcceptNSRequest,
        completion: @escaping (String?) -> Void) {
        debugPrint("getToken called")
        
        var env: AcceptSDKEnvironment;
        switch config.environment {
        case .ENV_TEST:
            env = AcceptSDKEnvironment.ENV_TEST
        case .ENV_LIVE:
            env = AcceptSDKEnvironment.ENV_LIVE
        }
        
        let handler = AcceptSDKHandler(environment: env)
        let request = AcceptSDKRequest()
        
        request.merchantAuthentication.name = config.clientName!
        request.merchantAuthentication.clientKey = config.clientKey!
        
        request.securePaymentContainerRequest.webCheckOutDataType.token.cardNumber = payload.cardNumber!
        request.securePaymentContainerRequest.webCheckOutDataType.token.expirationMonth = payload.expMonth!
        request.securePaymentContainerRequest.webCheckOutDataType.token.expirationYear = payload.expYear!
        request.securePaymentContainerRequest.webCheckOutDataType.token.cardCode = payload.cvc

        handler!.getTokenWithRequest(request, successHandler:  { (inResponse: AcceptSDKTokenResponse) -> () in
            var output = String(format: "Response: %@\nData Value: %@ \nDescription: %@", inResponse.getMessages().getResultCode(), inResponse.getOpaqueData().getDataValue(), inResponse.getOpaqueData().getDataDescriptor())
            output = output + String(format: "\nMessage Code: %@\nMessage Text: %@", inResponse.getMessages().getMessages()[0].getCode(), inResponse.getMessages().getMessages()[0].getText())
            
            debugPrint("token received!")
            debugPrint(output)
            
            AcceptNS.shared.delegate?.didCallGetToken()
            
            completion(inResponse.getOpaqueData().getDataValue())
        }) { (inError: AcceptSDKErrorResponse) -> () in
            let output = String(format: "Response:  %@\nError code: %@\nError text:   %@", inError.getMessages().getResultCode(), inError.getMessages().getMessages()[0].getCode(), inError.getMessages().getMessages()[0].getText())
            
            debugPrint("token failed")
            debugPrint(output)
            
            AcceptNS.shared.delegate?.didCallGetToken()
            
            completion(nil)
        }
        
        
    }
}
