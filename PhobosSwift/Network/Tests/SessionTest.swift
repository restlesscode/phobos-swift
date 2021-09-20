//
//
//  SessionTest.swift
//  PhobosSwiftNetwork-Unit-Tests
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

@testable import PhobosSwiftNetwork
import Alamofire
import Nimble
import Quick

class SessionTest: QuickSpec {
  override func spec() {
    testCrashs()
    testSession()
  }

  func testCrashs() {
    describe("Given 在测试环境中") {
      context("When 调用Session.pbs.allmethods") {
        _ = Session.pbs.default
        _ = Session.pbs.redirectorDoNotFollow
        _ = Session.pbs.insecure
        Session.pbs.default.pbs.addCertificate(data: Data())
        Session.pbs.default.pbs.removeAllCertificates()

        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }

  func testSession() {
    describe("Given 在测试环境中") {
      context("When 调用Session.pbs.addPublicKey") {
        let certificate = """
        MIINWTCCC0GgAwIBAgITfwAS4mESlUEZX6waYAAAABLiYTANBgkqhkiG9w0BAQsFADBPMQswCQYDVQQGEwJVUzEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSAwHgYDVQQDExdNaWNyb3NvZnQgUlNBIFRMUyBDQSAwMjAeFw0yMTA3MDYwMTUzMTNaFw0yMjAxMDYwMTUzMTNaMBcxFTATBgNVBAMTDHd3dy5iaW5nLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALCoO93BgJyXu7B6IgNXXzMF1x2gw1jZB0NXTok1zFUo1hdokCLXKi1qsIDMwfcmIyA5Fh6sSBMFEuhrnrO9l33MySnYzeZN/4LWr5mOElZ8okuEUWCKFHcCnKkAPRZ9bYpqo78BcYlsUd2KIlu7SB1MFdFEndQc1KvbQhYPavTxHaJKyNT8KB1fsnuArCgSWCA0oi8MS8YYMAek5lIWslakUwIkw8mNpa3jSMe56E1TVaJ2G6mMq5ixG7CFfY2+Q+5ys93+f7fzSWp3sArwGNXiQfAS/VyUEMLixEGvyzgYvA409CPxKT6FHAFzaxHUDXwijpWLSQhEBAzQcA99aBkCAwEAAaOCCWQwgglgMIIBfQYKKwYBBAHWeQIEAgSCAW0EggFpAWcAdwBGpVXrdfqRIDC1oolp9PN9ESxBdL79SbiFq/L8cP5tRwAAAXp5jilrAAAEAwBIMEYCIQDDOWNz+QlyysqZjuFWCJ+npkAXPTZq7g9KS6m3p5iSKQIhANP+aH5nnGh53Hdhy0YFxqQGMZPsBHQQAX6D0NrntQWpAHUAQcjKsd8iRkoQxqE6CUKHXk4xixsD6+tLx2jwkGKWBvYAAAF6eY4pOAAABAMARjBEAiBSFjFqOTN2ZTAojpn3b0Oralo0C9iKNjMXjKRXBTclkQIgfeLe7ULO4Rj4+W2eRSK15Vg7mkwCLA31yyFEhi4ANjwAdQBRo7D1/QF5nFZtuDd4jwykeswbJ8v3nohCmg3+1IsF5QAAAXp5jiqJAAAEAwBGMEQCIAvzMwb7vd4wY+gKv4pI2R6MDfu2MjpqRqDqFv3BeSwTAiB27usQ13NvrGOsxmFzhUw6/F265JPovj/LGbNt0Bq36zAnBgkrBgEEAYI3FQoEGjAYMAoGCCsGAQUFBwMBMAoGCCsGAQUFBwMCMD4GCSsGAQQBgjcVBwQxMC8GJysGAQQBgjcVCIfahnWD7tkBgsmFG4G1nmGF9OtggV2Fho5Bh8KYUAIBZAIBJzCBhwYIKwYBBQUHAQEEezB5MFMGCCsGAQUFBzAChkdodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL21zY29ycC9NaWNyb3NvZnQlMjBSU0ElMjBUTFMlMjBDQSUyMDAyLmNydDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AubXNvY3NwLmNvbTAdBgNVHQ4EFgQUIEGmEr2oUZVE7JAuVxYrsPzK4AcwDgYDVR0PAQH/BAQDAgSwMIIFbQYDVR0RBIIFZDCCBWCCDHd3dy5iaW5nLmNvbYIQZGljdC5iaW5nLmNvbS5jboITKi5wbGF0Zm9ybS5iaW5nLmNvbYIKKi5iaW5nLmNvbYIIYmluZy5jb22CFmllb25saW5lLm1pY3Jvc29mdC5jb22CEyoud2luZG93c3NlYXJjaC5jb22CGWNuLmllb25saW5lLm1pY3Jvc29mdC5jb22CESoub3JpZ2luLmJpbmcuY29tgg0qLm1tLmJpbmcubmV0gg4qLmFwaS5iaW5nLmNvbYIYZWNuLmRldi52aXJ0dWFsZWFydGgubmV0gg0qLmNuLmJpbmcubmV0gg0qLmNuLmJpbmcuY29tghBzc2wtYXBpLmJpbmcuY29tghBzc2wtYXBpLmJpbmcubmV0gg4qLmFwaS5iaW5nLm5ldIIOKi5iaW5nYXBpcy5jb22CD2JpbmdzYW5kYm94LmNvbYIWZmVlZGJhY2subWljcm9zb2Z0LmNvbYIbaW5zZXJ0bWVkaWEuYmluZy5vZmZpY2UubmV0gg5yLmJhdC5iaW5nLmNvbYIQKi5yLmJhdC5iaW5nLmNvbYISKi5kaWN0LmJpbmcuY29tLmNugg8qLmRpY3QuYmluZy5jb22CDiouc3NsLmJpbmcuY29tghAqLmFwcGV4LmJpbmcuY29tghYqLnBsYXRmb3JtLmNuLmJpbmcuY29tgg13cC5tLmJpbmcuY29tggwqLm0uYmluZy5jb22CD2dsb2JhbC5iaW5nLmNvbYIRd2luZG93c3NlYXJjaC5jb22CDnNlYXJjaC5tc24uY29tghEqLmJpbmdzYW5kYm94LmNvbYIZKi5hcGkudGlsZXMuZGl0dS5saXZlLmNvbYIPKi5kaXR1LmxpdmUuY29tghgqLnQwLnRpbGVzLmRpdHUubGl2ZS5jb22CGCoudDEudGlsZXMuZGl0dS5saXZlLmNvbYIYKi50Mi50aWxlcy5kaXR1LmxpdmUuY29tghgqLnQzLnRpbGVzLmRpdHUubGl2ZS5jb22CFSoudGlsZXMuZGl0dS5saXZlLmNvbYILM2QubGl2ZS5jb22CE2FwaS5zZWFyY2gubGl2ZS5jb22CFGJldGEuc2VhcmNoLmxpdmUuY29tghVjbndlYi5zZWFyY2gubGl2ZS5jb22CDGRldi5saXZlLmNvbYINZGl0dS5saXZlLmNvbYIRZmFyZWNhc3QubGl2ZS5jb22CDmltYWdlLmxpdmUuY29tgg9pbWFnZXMubGl2ZS5jb22CEWxvY2FsLmxpdmUuY29tLmF1ghRsb2NhbHNlYXJjaC5saXZlLmNvbYIUbHM0ZC5zZWFyY2gubGl2ZS5jb22CDW1haWwubGl2ZS5jb22CEW1hcGluZGlhLmxpdmUuY29tgg5sb2NhbC5saXZlLmNvbYINbWFwcy5saXZlLmNvbYIQbWFwcy5saXZlLmNvbS5hdYIPbWluZGlhLmxpdmUuY29tgg1uZXdzLmxpdmUuY29tghxvcmlnaW4uY253ZWIuc2VhcmNoLmxpdmUuY29tghZwcmV2aWV3LmxvY2FsLmxpdmUuY29tgg9zZWFyY2gubGl2ZS5jb22CEnRlc3QubWFwcy5saXZlLmNvbYIOdmlkZW8ubGl2ZS5jb22CD3ZpZGVvcy5saXZlLmNvbYIVdmlydHVhbGVhcnRoLmxpdmUuY29tggx3YXAubGl2ZS5jb22CEndlYm1hc3Rlci5saXZlLmNvbYITd2VibWFzdGVycy5saXZlLmNvbYIVd3d3LmxvY2FsLmxpdmUuY29tLmF1ghR3d3cubWFwcy5saXZlLmNvbS5hdTCBsAYDVR0fBIGoMIGlMIGioIGfoIGchk1odHRwOi8vbXNjcmwubWljcm9zb2Z0LmNvbS9wa2kvbXNjb3JwL2NybC9NaWNyb3NvZnQlMjBSU0ElMjBUTFMlMjBDQSUyMDAyLmNybIZLaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9tc2NvcnAvY3JsL01pY3Jvc29mdCUyMFJTQSUyMFRMUyUyMENBJTIwMDIuY3JsMFcGA1UdIARQME4wQgYJKwYBBAGCNyoBMDUwMwYIKwYBBQUHAgEWJ2h0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvbXNjb3JwL2NwczAIBgZngQwBAgEwHwYDVR0jBBgwFoAU/y9/4Qb0OPMt7SWNmML+DvZs/PowHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMA0GCSqGSIb3DQEBCwUAA4ICAQDRCtDosMuX8l+WeLQtxnL8fnAi/Jtyv9AQDSODj3pIrGVLKv/+9rPKJ22QEouFZVUhPYAuRR6B5vQboqCkLyMilqZlhpZOkEoKRXBuUmSwhO/tzc8FLSMcJhq0bcuVhd/49iv/oaWX5eyniT00XEScEDACUYE8Jz5lsnuQUGHfoUy2I2gcRdlGmYSq25bp7RHiQHmtTooQNIl2JxD50id7rMkjcS46qWwvO4W3Z45rDSjYAbXCrN+kBqMBdnu7Y3P6O+Yke9qIsLJp5xrvNfEkjvBpVSt1etEOos8rdm/KJ4mQ2toloXQ/gOA1LC7k5KlBixou4JfsNfQl5MM+nRHTc1oNGMlSbGCCAgmuYdfem6H34NUbYtGA7FpLwkITb75iKRb1pm/ME5Yn+R64EDgAqWwUF5jOy7xXYrxQpzFAlkCtPfvQ3YSrwGOykLmthxlYaxSgJ8VkoOl6kEyrfNjOKLWVMmXYe1PxITO84F4HXwE3p9QP/4+AYN2kQvHtp1kFL4+m021nFVNLNmhL5RBenHGKs3OuopWe+4TDAv7fMzIkOjk4HtgcRjxHvy7cVYzhwaTRemEGtC7csvesZOQ7ROjnq+y+3YH/P4gbXcVeMDXwnb5MQHll1/FABRn0gTRCBAxfMAYVicEqqzMJQ8gqHTL4dOw7kIN1WkGefZe51g==
        """
        let pubKey = """
        -----BEGIN PUBLIC KEY-----
        MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3CguP+6UfxGv7qs9sd1r
        p5Gj94L9JbVMjezU2RMdwgXhdeDI0YxVu0flK1tJ9d8bOlZOimmBOl6jHpHc+d9D
        1jDAQwnNvMWy+8hQrEKs7OaZIQH1owvyX47Gf1nzuLIG2NVhdoqWCahBANvxthZs
        ns0dZK/qYOP0b+33uFidlUx+omxZQEVKsC7laUGin/7VpD77YorY812oB23iqljw
        ttNM1RQohwhlbmGRqfj9NIyppT+iDZMdqBzQnwmjvDvuSdnwDbg4nEFIFA8g7U6T
        lKnG5xYVYNHbnuCbALyKBtEH11vzmwwesi+nLDMLanWQ8595z7EUUPG985OUwZZI
        xQIDAQAB
        -----END PUBLIC KEY-----
        """
        let pubKeySession = Session.pbs.default
        pubKeySession.pbs.addPublicKey(publicKey: pubKey)
        let cerSession = Session.pbs.default
        if let data = Data(base64Encoded: certificate) {
          cerSession.pbs.addCertificate(data: data)
        } else {
          expect(false).to(beTrue())
        }
        let correctUrl = "https://cn.bing.com"
        let incorrectUrl = "https://baidu.com"
        it("Then 请求通过") {
          waitUntil(timeout: .seconds(10), action: { done in
            pubKeySession.request(correctUrl,
                                  method: .options,
                                  parameters: nil,
                                  encoding: URLEncoding.default,
                                  headers: HTTPHeaders([:]))
              .responseDecodable { (response: DataResponse<ConceptDetailResponse, AFError>) in
                defer { done() }
                let statusCode = response.response?.statusCode ?? 0
                expect(statusCode < 300 && statusCode >= 200).to(beTrue())
              }
          })
          waitUntil(timeout: .seconds(10), action: { done in
            pubKeySession.request(incorrectUrl,
                                  method: .options,
                                  parameters: nil,
                                  encoding: URLEncoding.default,
                                  headers: HTTPHeaders([:]))
              .responseDecodable { (response: DataResponse<ConceptDetailResponse, AFError>) in
                defer { done() }
                let statusCode = response.response?.statusCode ?? 0
                expect(statusCode < 300 && statusCode >= 200).to(beFalse())
              }
          })
          waitUntil(timeout: .seconds(10), action: { done in
            cerSession.request(correctUrl,
                               method: .options,
                               parameters: nil,
                               encoding: URLEncoding.default,
                               headers: HTTPHeaders([:]))
              .responseDecodable { (response: DataResponse<ConceptDetailResponse, AFError>) in
                defer { done() }
                let statusCode = response.response?.statusCode ?? 0
                expect(statusCode < 300 && statusCode >= 200).to(beTrue())
              }
          })
          waitUntil(timeout: .seconds(10), action: { done in
            cerSession.request(incorrectUrl,
                               method: .options,
                               parameters: nil,
                               encoding: URLEncoding.default,
                               headers: HTTPHeaders([:]))
              .responseDecodable { (response: DataResponse<ConceptDetailResponse, AFError>) in
                defer { done() }
                let statusCode = response.response?.statusCode ?? 0
                expect(statusCode < 300 && statusCode >= 200).to(beFalse())
              }
          })
        }
      }
    }
  }
}
