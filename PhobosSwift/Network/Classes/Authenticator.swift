//
//
//  Authenticator.swift
//  PhobosSwiftNetwork
//
//  Copyright (c) 2021 Restless Codes Team (https://github.com/restlesscode/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift

extension PBSNetwork {
  public class Authenticator {
    static let shared = Authenticator(session: Session.default)
    private let session: Session
    public var currentToken: Token? = Token(accessToken: "xxxx")
    private let queue = DispatchQueue(label: "Autenticator.\(UUID().uuidString)")

    // this publisher is shared amongst all calls that request a token refresh
    private var refreshPublisher: Observable<Token>?

    init(session: Session = Session.default) {
      self.session = session
    }

    func validToken(forceRefresh: Bool = false) -> Observable<Token> {
      queue.sync { [weak self] in
        // scenario 1: we're already loading a new token
        if let publisher = self?.refreshPublisher {
          print("正在刷新token")
          return publisher
        }

        // scenario 2: we don't have a token at all, the user should probably log in
        guard let token = self?.currentToken else {
          print("没有token, 请登录")
          return Observable.error(AuthenticationError.loginRequired)
        }

        // scenario 3: we already have a valid token and don't want to force a refresh
        if token.isValid, !forceRefresh {
          print("token有效,继续请求")
          return Observable.just(token)
        }

        // scenario 4: we need a new token
        print("需要新的token")
        let publisher = refreshToken()
          .share(replay: 1, scope: .whileConnected)
          .do(onNext: { [weak self] token in
                guard let self = self else { return }
                self.currentToken = token
              },
              onCompleted: { [weak self] in
                guard let self = self else { return }
                self.queue.sync {
                  self.refreshPublisher = nil
                }
              })

        self?.refreshPublisher = publisher
        return publisher
      }
    }

    func refreshToken() -> Observable<Token> {
      Observable<Token>.create { observer in
        let endpoint = URL(string: "https://yapi.xxxxx.cn/mock/101/iosdk/refreshToken")!
        APIRequest.request(endpoint,
                           method: .get,
                           parameters: nil,
                           encoding: JSONEncoding.default,
                           headers: nil,
                           session: Session.default)
          .then { (result: Result<APIRequest.ModelResponse<Token>, Error>) in
            switch result {
            case let .success(modelResponse):
              observer.onNext(modelResponse.model)
            case let .failure(error):
              observer.onError(error)
            }
          }
        return Disposables.create()
      }
    }
  }

  public struct Token: Decodable {
    var isValid: Bool {
      guard let token = accessToken,
            token != "" else { return false }
      return true
    }

    var accessToken: String?
    var refreshToken: String?
    var expires: Int?
  }

  enum AuthenticationError: Error {
    case loginRequired
  }

  public class NetworkManager {
    public static let shared = NetworkManager(session: Session.default)
    private let session: Session
    private let authenticator: Authenticator

    init(session: Session = Session.default) {
      self.session = session

      authenticator = Authenticator(session: session)
    }

    public func performAuthenticateRequest(method: HTTPMethod,
                                           url: String,
                                           body: [String: Any]?,
                                           encoding: ParameterEncoding = URLEncoding.default,
                                           headers: [String: String]?) -> Observable<APIRequest.Response> {
      print("第一次请求")
      return authenticator.validToken()
        .flatMap { _ in
          APIRequest.performRequest(method: method, url: url, body: body, headers: headers)
        }
        .catch { error in
          guard let err = error.asAFError,
                err.responseCode == 401 else {
            return Observable.error(error)
          }
          return self.authenticator.validToken(forceRefresh: true)
            .flatMap { _ in
              APIRequest.performRequest(method: method, url: url, body: ["token": self.authenticator.currentToken?.accessToken ?? ""], headers: headers)
            }
        }
    }
  }
}

extension PBSNetwork.APIRequest {
  public static func performRequest(method: HTTPMethod,
                                    url: String,
                                    body: [String: Any]?,
                                    encoding: ParameterEncoding = URLEncoding.default,
                                    headers: [String: String]?) -> Observable<Response> {
    print("请求")
    return Observable<Response>.create { observer in
      let endpoint = URL(string: url)!
      PBSNetwork.APIRequest.request(endpoint,
                                    method: .get,
                                    parameters: body,
                                    encoding: JSONEncoding.default,
                                    headers: headers,
                                    session: Session.default)
        .then { (result: Result<PBSNetwork.APIRequest.Response, Error>) in
          switch result {
          case let .success(response):
            observer.onNext(response)
          case let .failure(error):
            observer.onError(error)
          }
        }
      return Disposables.create()
    }
  }
}

// struct NetworkManager {
//    private let session: NetworkSession
//    private let authenticator: Authenticator
//
//    init(session: NetworkSession = URLSession.shared) {
//        self.session = session
//        self.authenticator = Authenticator(session: session)
//    }
//
//    func performAuthenticatedRequest() -> AnyPublisher<Response, Error> {
//        let url = URL(string: "https://donnys-app.com/authenticated/resource")!
//        return authenticator.validToken()
//            .flatMap({ token in
//                // we can now use this token to authenticate the request
//                session.publisher(for: url, token: token)
//            })
//            .tryCatch({ error -> AnyPublisher<Data, Error> in
//                guard let serviceError = error as? ServiceError,
//                      serviceError.errors.contains(ServiceErrorMessage.invalidToken) else {
//                    throw error
//                }
//
//                return authenticator.validToken(forceRefresh: true)
//                    .flatMap({ token in
//                        // we can now use this new token to authenticate the second attempt at making this request
//                        session.publisher(for: url, token: token)
//                    })
//                    .eraseToAnyPublisher()
//            })
//            .decode(type: Response.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
// }

//
// protocol NetworkSession: AnyObject {
//    func publisher(for url: URL, token: Token?) -> Observable<Data>
// }
//
// extension URLSession: NetworkSession {
//    func publisher(for url: URL, token: Token?) -> Observable<Data> {
//        return Observable.create { (observer) -> Disposable in
//            return Disposables.create()
//        }
//    }
// }
