//
//
//  APIRequest.swift
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
import PhobosSwiftCore
import PhobosSwiftLog

extension PBSNetwork {
  public enum APIRequest {
    public typealias Parameters = [String: Any]
    public typealias Headers = [String: String]
    public typealias Response = AFDataResponse<Any>
    public typealias DownloadResponse = AFDownloadResponse<Any>
  }
}

extension PBSNetwork.APIRequest: PBSPromisableType {
  public static func request<T: Decodable>(_ url: URLConvertible,
                                           method: HTTPMethod,
                                           parameters: Parameters? = nil,
                                           encoding: ParameterEncoding = JSONEncoding.default,
                                           headers: Headers? = nil,
                                           session: Session? = nil) -> PBSPromisable<Result<T, Error>> {
    PBSPromisable.create { resolve in
      let _session = session ?? Session.pbs.insecure

      _session.request(url, method: method, parameters: parameters, encoding: encoding, headers: HTTPHeaders(headers ?? [:]))
        .validate(statusCode: 200..<300)
        .responseDecodable { (response: DataResponse<T, AFError>) in
          PBSLogger.logger.logResponse(payload: response.data)
          if let error = response.error {
            PBSLogger.logger.error(message: error.localizedDescription, context: "network.error")
            return resolve(.failure(error))
          } else {
            switch response.result {
            case let .success(decodable):
              resolve(.success(decodable))
            case let .failure(error):
              PBSLogger.logger.error(message: error.localizedDescription, context: "network.error")
              return resolve(.failure(error))
            }
          }
        }
    }
  }

  /// get
  public static func get<T>(_ url: URLConvertible,
                            parameters: Parameters? = nil,
                            encoding: ParameterEncoding = URLEncoding.default,
                            headers: Headers? = nil,
                            session: Session? = nil) -> PBSPromisable<Result<T, Error>> where T: Decodable {
    request(url, method: .get, parameters: parameters, encoding: encoding, headers: headers, session: session)
  }

  /// post
  public static func post<T>(_ url: URLConvertible,
                             parameters: Parameters? = nil,
                             encoding: ParameterEncoding = JSONEncoding.default,
                             headers: Headers? = nil,
                             session: Session? = nil) -> PBSPromisable<Result<T, Error>> where T: Decodable {
    request(url, method: .post, parameters: parameters, encoding: encoding, headers: headers, session: session)
  }

  /// put
  public static func put<Wrapper>(_ url: URLConvertible,
                                  parameters: Parameters? = nil,
                                  encoding: ParameterEncoding = JSONEncoding.default,
                                  headers: Headers? = nil,
                                  session: Session? = nil) -> PBSPromisable<Result<Wrapper, Error>> where Wrapper: Decodable {
    request(url, method: .put, parameters: parameters, encoding: encoding, headers: headers, session: session)
  }
}

extension PBSNetwork.APIRequest {
  ///
  public static func request<Wrapper: Decodable>(_ url: URLConvertible,
                                                 method: HTTPMethod,
                                                 parameters: Parameters? = nil,
                                                 encoding: ParameterEncoding = JSONEncoding.default,
                                                 headers: Headers? = nil,
                                                 session: Session? = nil) -> PBSPromisable<Result<ModelResponse<Wrapper>, Error>> {
    PBSPromisable.create { resolve in
      let _session = session ?? Session.pbs.insecure

      _session.request(url, method: method, parameters: parameters, encoding: encoding, headers: HTTPHeaders(headers ?? [:]))
        .validate(statusCode: 200..<300)
        .responseDecodable { (response: DataResponse<Wrapper, AFError>) in

          PBSLogger.logger.logResponse(payload: response.data)

          if let error = response.error {
            PBSLogger.logger.error(message: error.localizedDescription, context: "network.error")
            return resolve(.failure(error))
          } else {
            switch response.result {
            case let .success(decodable):
              let dataResponse = ModelResponse(model: decodable, response: response.response!)
              resolve(.success(dataResponse))
            case let .failure(error):
              PBSLogger.logger.error(message: error.localizedDescription, context: "network.error")
              return resolve(.failure(error))
            }
          }
        }
    }
  }

  /// get
  public static func get<Wrapper>(_ url: URLConvertible,
                                  parameters: Parameters? = nil,
                                  encoding: ParameterEncoding = URLEncoding.default,
                                  headers: Headers? = nil,
                                  session: Session? = nil) -> PBSPromisable<Result<ModelResponse<Wrapper>, Error>> where Wrapper: Decodable {
    request(url, method: .get, parameters: parameters, encoding: encoding, headers: headers, session: session)
  }

  /// post
  public static func post<Wrapper>(_ url: URLConvertible,
                                   parameters: Parameters? = nil,
                                   encoding: ParameterEncoding = JSONEncoding.default,
                                   headers: Headers? = nil,
                                   session: Session? = nil) -> PBSPromisable<Result<ModelResponse<Wrapper>, Error>> where Wrapper: Decodable {
    request(url, method: .post, parameters: parameters, encoding: encoding, headers: headers, session: session)
  }

  /// put
  public static func put<Wrapper>(_ url: URLConvertible,
                                  parameters: Parameters? = nil,
                                  encoding: ParameterEncoding = JSONEncoding.default,
                                  headers: Headers? = nil,
                                  session: Session? = nil) -> PBSPromisable<Result<ModelResponse<Wrapper>, Error>> where Wrapper: Decodable {
    request(url, method: .put, parameters: parameters, encoding: encoding, headers: headers, session: session)
  }
}

///
extension PBSNetwork.APIRequest {
  /// 直接发起请求，获得的结果为Alamofire自带的DataResponse，用Result进行Wrapper
  public static func request(_ url: URLConvertible,
                             method: HTTPMethod,
                             parameters: Parameters? = nil,
                             encoding: ParameterEncoding = JSONEncoding.default,
                             headers: Headers? = nil,
                             session: Session? = nil) -> PBSPromisable<Result<AFDataResponse<Data>, Error>> {
    PBSPromisable.create { resolve in
      let _session = session ?? Session.pbs.insecure
      _session.request(url,
                       method: method,
                       parameters: parameters,
                       encoding: encoding,
                       headers: HTTPHeaders(headers ?? [:]))
        .validate(statusCode: 200..<300)
        .responseData(completionHandler: { (response: AFDataResponse<Data>) in
          PBSLogger.logger.logResponse(payload: response.data)
          if let error = response.error {
            PBSLogger.logger.error(message: error.localizedDescription, context: "network.error")
            resolve(.failure(error))
          } else {
            resolve(.success(response))
          }
        })
    }
  }

  /// 直接发起请求，获得的结果转为Alamofire自带的DataResponse，用Result进行Wrapper
  public static func request(_ url: URLConvertible,
                             method: HTTPMethod,
                             parameters: Parameters? = nil,
                             encoding: ParameterEncoding = JSONEncoding.default,
                             headers: Headers? = nil,
                             session: Session? = nil) -> PBSPromisable<Result<Response, Error>> {
    PBSPromisable.create { resolve in
      let _session = session ?? Session.pbs.insecure
      _session.request(url,
                       method: method,
                       parameters: parameters,
                       encoding: encoding,
                       headers: HTTPHeaders(headers ?? [:]))
        .validate(statusCode: 200..<300)
        .responseJSON { response in
          PBSLogger.logger.logResponse(payload: response.data)
          if let error = response.error {
            PBSLogger.logger.error(message: error.localizedDescription, context: "network.error")
            resolve(.failure(error))
          } else {
            resolve(.success(response))
          }
        }
    }
  }

  /// 发起下载请求
  public static func downloadRequest(url: URL,
                                     method: HTTPMethod = .get,
                                     body: [String: Any]? = nil,
                                     encoding: ParameterEncoding = URLEncoding.default,
                                     headers: [String: String]? = nil,
                                     session: Session? = nil,
                                     destination: DownloadRequest.Destination? = nil) -> PBSPromisable<Result<DownloadResponse, Error>> {
    PBSPromisable.create { resolve in
      let _session = session ?? Session.pbs.insecure
      _session.download(url, method: method, parameters: body, encoding: encoding, headers: HTTPHeaders(headers ?? [:]), to: destination)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
          PBSLogger.logger.logResponse(payload: response.debugDescription.data(using: .utf8))
          if let error = response.error {
            PBSLogger.logger.error(message: error.localizedDescription, context: "network.error")
            resolve(.failure(error))
          } else {
            resolve(.success(response))
          }
        }
    }
  }

  /// 发起下载请求
  public static func downloadDataRequest(url: URL,
                                         method: HTTPMethod = .get,
                                         body: [String: Any]? = nil,
                                         encoding: ParameterEncoding = URLEncoding.default,
                                         headers: [String: String]? = nil,
                                         session: Session? = nil,
                                         destination: DownloadRequest.Destination? = nil) -> PBSPromisable<Result<AFDownloadResponse<Data>, Error>> {
    PBSPromisable.create { resolve in
      let _session = session ?? Session.pbs.insecure
      _session.download(url, method: method, parameters: body, encoding: encoding, headers: HTTPHeaders(headers ?? [:]), to: destination)
        .validate(statusCode: 200..<300)
        .responseData { response in
          PBSLogger.logger.logResponse(payload: response.debugDescription.data(using: .utf8))
          if let error = response.error {
            PBSLogger.logger.error(message: error.localizedDescription, context: "network.error")
            resolve(.failure(error))
          } else {
            resolve(.success(response))
          }
        }
    }
  }
}

extension PBSNetwork.APIRequest {
  ///
  public struct ModelResponse<T: Decodable> {
    ///
    public internal(set) var model: T
    ///
    public internal(set) var response: HTTPURLResponse
  }
}
