//
//  NetworkHandler.swift
//  anoop_assignment
//
//  Created by Apple on 26/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

typealias NetworkCompletionHandler = (Data?, URLResponse?, Error?) -> Void
public typealias ErrorHandler = (String) -> Void

class NetworkHandler {

    private var task: URLSessionDataTask?

    func send<U: Decodable>(urlString: String,
                            body: Encodable?,
                            method: HttpMethod,
                            headers: [String: String] = [:],
                            successHandler: @escaping (U) -> Void,
                            errorHandler: @escaping ErrorHandler) {

        let completionHandler: NetworkCompletionHandler = { (data, urlResponse, error) in
            if let error = error {
                print(error.localizedDescription)
                errorHandler(error.localizedDescription)
                return
            }

            if self.isSuccessCode(urlResponse) {
                guard let data = data else {
                    print("Unable to parse the response in given type")
                    return errorHandler("")
                }
                do {
                    let responseObject = try JSONDecoder().decode(U.self, from: data)
                    print("Response::", responseObject)
                    successHandler(responseObject)
                    return
                } catch  let error {
                    errorHandler(error.localizedDescription)
                }


            } else if let response = urlResponse as? HTTPURLResponse, response.statusCode == 401 {
                errorHandler(kSessionExpired)
            } else {
                errorHandler(kGenerikErrorMessage)
            }

        }

        guard let url = URL(string: urlString) else {
            return errorHandler("Unable to create URL from given string")
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 90
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if request.allHTTPHeaderFields?["Content-Type"] == nil {
            request.allHTTPHeaderFields?["Content-Type"] = "application/json"
        }
        if method == .POST || method == .PUT, let body = body {
            request.httpBody = body.json
        }

        task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task?.resume()
    }

    func cancelRequest() {
        task?.cancel()
    }

    private func isSuccessCode(_ statusCode: Int) -> Bool {
        return statusCode >= 200 && statusCode < 300
    }

    private func isSuccessCode(_ response: URLResponse?) -> Bool {
        guard let urlResponse = response as? HTTPURLResponse else {
            return false
        }

        return isSuccessCode(urlResponse.statusCode)
    }
}

extension Encodable {
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}

enum HttpMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}
