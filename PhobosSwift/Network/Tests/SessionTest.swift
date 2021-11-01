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
        MIINWzCCC0OgAwIBAgITfwAZY6zVenisR3gJUQAAABljrDANBgkqhkiG9w0BAQsFADBPMQswCQYDVQQGEwJVUzEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSAwHgYDVQQDExdNaWNyb3NvZnQgUlNBIFRMUyBDQSAwMjAeFw0yMTA5MzAwMTQzMzhaFw0yMjAzMzAwMTQzMzhaMBcxFTATBgNVBAMTDHd3dy5iaW5nLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKSz9Gfo3qYZ0sgk/x5rvNFKwQYp/woiK64gnejdGMn3GKA4uGQsxja3n15NKICSLe5WVmQxlxcXQF+kaaqqRcC5BoCD2QSZNVh3ZhP9fEco4Q/t97sb+Kfv3cFacLG10eJcSxADW4OOkrbe6Mm8wmzcweiy8ElKMzegwKB+YI/9u19OT2WObdSM9GKDSVJIw4TXI3IEvQa0PyPIk2A+LiYN01D7tTjtNMuntFJrer7bHsbrmrJu9iVUdqRYg3Axg+pXuEt23kcH67a2m7fNDI+S8w3gq21e4iBtWPJ2ef8bUUivN3aeS9Cr9ZY4rEUVNDTnICoezxvAbLW+eC5jjmUCAwEAAaOCCWYwggliMIIBfwYKKwYBBAHWeQIEAgSCAW8EggFrAWkAdQApeb7wnjk5IfBWc59jpXflvld9nGAK+PlNXSZcJV3HhAAAAXw0aE91AAAEAwBGMEQCID8MejmGdRsiJHS9XgDwRLPkpbQT/kLIO3oLY8FQC6TuAiBrDUYaG+8CAUrbnb1o4o/jcsXsrndJnyqcaYT8DmpUYwB3AFGjsPX9AXmcVm24N3iPDKR6zBsny/eeiEKaDf7UiwXlAAABfDRoUDQAAAQDAEgwRgIhAMPe5w/rrq+CYszV8A+TKhXcffHZL0muGbOvTPh6dq9tAiEAmDiKOy4jVfLsg8QMpIBJtQSja53Xi2DNtJkhDb5Q4cEAdwBByMqx3yJGShDGoToJQodeTjGLGwPr60vHaPCQYpYG9gAAAXw0aE7rAAAEAwBIMEYCIQD6Hm5PUAkQxRrKomxsk1UIpIo9+pYHgK9JI50JeTjVKQIhAMGK/VJzF4whOX2Bxu1UF9CwzcOr/7sf1bpFlDNuoPWoMCcGCSsGAQQBgjcVCgQaMBgwCgYIKwYBBQUHAwEwCgYIKwYBBQUHAwIwPgYJKwYBBAGCNxUHBDEwLwYnKwYBBAGCNxUIh9qGdYPu2QGCyYUbgbWeYYX062CBXYWGjkGHwphQAgFkAgEnMIGHBggrBgEFBQcBAQR7MHkwUwYIKwYBBQUHMAKGR2h0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvbXNjb3JwL01pY3Jvc29mdCUyMFJTQSUyMFRMUyUyMENBJTIwMDIuY3J0MCIGCCsGAQUFBzABhhZodHRwOi8vb2NzcC5tc29jc3AuY29tMB0GA1UdDgQWBBSepvy3TlByHLqgLWqxI37KpAuFWDAOBgNVHQ8BAf8EBAMCBLAwggVtBgNVHREEggVkMIIFYIIMd3d3LmJpbmcuY29tghBkaWN0LmJpbmcuY29tLmNughMqLnBsYXRmb3JtLmJpbmcuY29tggoqLmJpbmcuY29tgghiaW5nLmNvbYIWaWVvbmxpbmUubWljcm9zb2Z0LmNvbYITKi53aW5kb3dzc2VhcmNoLmNvbYIZY24uaWVvbmxpbmUubWljcm9zb2Z0LmNvbYIRKi5vcmlnaW4uYmluZy5jb22CDSoubW0uYmluZy5uZXSCDiouYXBpLmJpbmcuY29tghhlY24uZGV2LnZpcnR1YWxlYXJ0aC5uZXSCDSouY24uYmluZy5uZXSCDSouY24uYmluZy5jb22CEHNzbC1hcGkuYmluZy5jb22CEHNzbC1hcGkuYmluZy5uZXSCDiouYXBpLmJpbmcubmV0gg4qLmJpbmdhcGlzLmNvbYIPYmluZ3NhbmRib3guY29tghZmZWVkYmFjay5taWNyb3NvZnQuY29tghtpbnNlcnRtZWRpYS5iaW5nLm9mZmljZS5uZXSCDnIuYmF0LmJpbmcuY29tghAqLnIuYmF0LmJpbmcuY29tghIqLmRpY3QuYmluZy5jb20uY26CDyouZGljdC5iaW5nLmNvbYIOKi5zc2wuYmluZy5jb22CECouYXBwZXguYmluZy5jb22CFioucGxhdGZvcm0uY24uYmluZy5jb22CDXdwLm0uYmluZy5jb22CDCoubS5iaW5nLmNvbYIPZ2xvYmFsLmJpbmcuY29tghF3aW5kb3dzc2VhcmNoLmNvbYIOc2VhcmNoLm1zbi5jb22CESouYmluZ3NhbmRib3guY29tghkqLmFwaS50aWxlcy5kaXR1LmxpdmUuY29tgg8qLmRpdHUubGl2ZS5jb22CGCoudDAudGlsZXMuZGl0dS5saXZlLmNvbYIYKi50MS50aWxlcy5kaXR1LmxpdmUuY29tghgqLnQyLnRpbGVzLmRpdHUubGl2ZS5jb22CGCoudDMudGlsZXMuZGl0dS5saXZlLmNvbYIVKi50aWxlcy5kaXR1LmxpdmUuY29tggszZC5saXZlLmNvbYITYXBpLnNlYXJjaC5saXZlLmNvbYIUYmV0YS5zZWFyY2gubGl2ZS5jb22CFWNud2ViLnNlYXJjaC5saXZlLmNvbYIMZGV2LmxpdmUuY29tgg1kaXR1LmxpdmUuY29tghFmYXJlY2FzdC5saXZlLmNvbYIOaW1hZ2UubGl2ZS5jb22CD2ltYWdlcy5saXZlLmNvbYIRbG9jYWwubGl2ZS5jb20uYXWCFGxvY2Fsc2VhcmNoLmxpdmUuY29tghRsczRkLnNlYXJjaC5saXZlLmNvbYINbWFpbC5saXZlLmNvbYIRbWFwaW5kaWEubGl2ZS5jb22CDmxvY2FsLmxpdmUuY29tgg1tYXBzLmxpdmUuY29tghBtYXBzLmxpdmUuY29tLmF1gg9taW5kaWEubGl2ZS5jb22CDW5ld3MubGl2ZS5jb22CHG9yaWdpbi5jbndlYi5zZWFyY2gubGl2ZS5jb22CFnByZXZpZXcubG9jYWwubGl2ZS5jb22CD3NlYXJjaC5saXZlLmNvbYISdGVzdC5tYXBzLmxpdmUuY29tgg52aWRlby5saXZlLmNvbYIPdmlkZW9zLmxpdmUuY29tghV2aXJ0dWFsZWFydGgubGl2ZS5jb22CDHdhcC5saXZlLmNvbYISd2VibWFzdGVyLmxpdmUuY29tghN3ZWJtYXN0ZXJzLmxpdmUuY29tghV3d3cubG9jYWwubGl2ZS5jb20uYXWCFHd3dy5tYXBzLmxpdmUuY29tLmF1MIGwBgNVHR8EgagwgaUwgaKggZ+ggZyGTWh0dHA6Ly9tc2NybC5taWNyb3NvZnQuY29tL3BraS9tc2NvcnAvY3JsL01pY3Jvc29mdCUyMFJTQSUyMFRMUyUyMENBJTIwMDIuY3JshktodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL21zY29ycC9jcmwvTWljcm9zb2Z0JTIwUlNBJTIwVExTJTIwQ0ElMjAwMi5jcmwwVwYDVR0gBFAwTjBCBgkrBgEEAYI3KgEwNTAzBggrBgEFBQcCARYnaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9tc2NvcnAvY3BzMAgGBmeBDAECATAfBgNVHSMEGDAWgBT/L3/hBvQ48y3tJY2Ywv4O9mz8+jAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwDQYJKoZIhvcNAQELBQADggIBAMSWmxybEy+7DfqTjbQvyg+QHsK5ZdakLLVnmlHi/DhDYOXRDutAjNa26QFTTq+t8ZfsDVsJqpynyVVsY1r+5UPZ5Qqb579wjHrxkricfIHW4OPrrcvbQExmw6YhTx4Xi22Ml2yrY5I3ukV+02dmZTFtSwpI5mYD9TvdrNU+sBjIdw6kLtxQfNwMcT08HQKwMB2Km8ggRmmEcPtPt1x3eWB1wMQSsPfg9QdBevV92jZOdj0zVGl3AuIqyTE89CohySsBbGE0Fzr6EDj75iS7iijqNd1z41jlBlijQBRrT3yCv/FKARkMmdm1r8JEabcD+WtqtRibPgkt7ELhe/RpXpCn3mEajrt0fWZVivNuYiDi9OP2qOoCa56sN5cGPNN2XMfIqQ83ynuG1qKBUS9g2dJ0qaCShUUdS51AEbn+P1YC2Exv6KF0acohJIxa8jLPR55n+eyTbh4w/G2DSepiKXal3w+DkBQ5RhNDb8GBuLaog+EGiZtuW1tfgjDevOi9YN5lnYxf+WVmNa3q483H1STZrjTDJ9qGohcV9Me56Ux9RHcLOj5odDmTe7nhF2QcpuEABAiph14bpm7SKPucoLxl9pdXzJmtoQgLGuRnjkbZACB3mXZWpLoCu/9aHbBBnndZUoLM/CDTJnBF2wRD5dTsCCh3ZVRelaZ9bQtf5DlO
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
