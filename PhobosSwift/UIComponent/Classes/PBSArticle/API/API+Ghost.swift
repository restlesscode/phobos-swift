//
//
//  API+Ghost.swift
//  PhobosSwiftUIComponent
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
import PhobosSwiftNetwork
import RxSwift
import UIKit

///
public struct PBSArticleRequest {
  ///
  public static func getGhostPosts() -> Observable<[PBSGhostPostResponse.Post]> {
    Observable.create { observable in
      
      let parameters: PBSNetwork.APIRequest.Parameters = ["key": Resource.Constants.kGhostAPIKey,
                                                          "include": "tags,authors"]
      
      let headers: PBSNetwork.APIRequest.Headers = [:]
      
      PBSNetwork.APIRequest.get(Resource.API.kGhostUrl,
                                parameters: parameters,
                                encoding: URLEncoding.default,
                                headers: headers).then { (response: Result<PBSGhostPostResponse, Error>) -> Result<[PBSGhostPostResponse.Post], Error> in
                                  
                                  switch response {
                                  case let .success(response):
                                    observable.onNext(response.posts)
                                    observable.onCompleted()
                                    return Result.success(response.posts)
                                  case let .failure(error):
                                    observable.onError(error)
                                    return Result.failure(error)
                                  }
                                }
      
      return Disposables.create()
    }
  }
}
