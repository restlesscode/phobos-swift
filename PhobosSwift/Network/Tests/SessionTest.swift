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
        MIIM3zCCCsegAwIBAgITawAMbdcfI5Nyb1TMVAAAAAxt1zANBgkqhkiG9w0BAQsFADBPMQswCQYDVQQGEwJVUzEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSAwHgYDVQQDExdNaWNyb3NvZnQgUlNBIFRMUyBDQSAwMTAeFw0yMTA0MTIwMjAxMTBaFw0yMTEwMTIwMjAxMTBaMBcxFTATBgNVBAMTDHd3dy5iaW5nLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANwoLj/ulH8Rr+6rPbHda6eRo/eC/SW1TI3s1NkTHcIF4XXgyNGMVbtH5StbSfXfGzpWToppgTpeox6R3PnfQ9YwwEMJzbzFsvvIUKxCrOzmmSEB9aML8l+Oxn9Z87iyBtjVYXaKlgmoQQDb8bYWbJ7NHWSv6mDj9G/t97hYnZVMfqJsWUBFSrAu5WlBop/+1aQ++2KK2PNdqAdt4qpY8LbTTNUUKIcIZW5hkan4/TSMqaU/og2THagc0J8Jo7w77knZ8A24OJxBSBQPIO1Ok5SpxucWFWDR257gmwC8igbRB9db85sMHrIvpywzC2p1kPOfec+xFFDxvfOTlMGWSMUCAwEAAaOCCOowggjmMIIBAwYKKwYBBAHWeQIEAgSB9ASB8QDvAHUAfT7y+I//iFVoJMLAyp5SiXkrxQ54CX8uapdomX4i8NcAAAF4w9joHgAABAMARjBEAiAQjusD9By8AkZJ1QD5gXjRbEXe4gfrJHAQsJlbsH5lXQIgEfa2jm93Xt9gIjNAVYqrpXg1j9ucIUGssw6Vr5D8ex0AdgBElGUusO7Or8RAB9io/ijA2uaCvtjLMbU/0zOWtbaBqAAAAXjD2OhtAAAEAwBHMEUCIQCWxZHw8JGJDzNPDB+45SFRZdN6m75jEeDihLiOaGRXygIgVYw695kMy78/1176ru5/LPPzOT9CsrRpzpF+JGHiuT4wJwYJKwYBBAGCNxUKBBowGDAKBggrBgEFBQcDATAKBggrBgEFBQcDAjA+BgkrBgEEAYI3FQcEMTAvBicrBgEEAYI3FQiH2oZ1g+7ZAYLJhRuBtZ5hhfTrYIFdhYaOQYfCmFACAWQCAScwgYcGCCsGAQUFBwEBBHsweTBTBggrBgEFBQcwAoZHaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9tc2NvcnAvTWljcm9zb2Z0JTIwUlNBJTIwVExTJTIwQ0ElMjAwMS5jcnQwIgYIKwYBBQUHMAGGFmh0dHA6Ly9vY3NwLm1zb2NzcC5jb20wHQYDVR0OBBYEFGwzqsSUKx0F8IpiLsTyNf02XrqTMA4GA1UdDwEB/wQEAwIEsDCCBW0GA1UdEQSCBWQwggVgggx3d3cuYmluZy5jb22CEGRpY3QuYmluZy5jb20uY26CEyoucGxhdGZvcm0uYmluZy5jb22CCiouYmluZy5jb22CCGJpbmcuY29tghZpZW9ubGluZS5taWNyb3NvZnQuY29tghMqLndpbmRvd3NzZWFyY2guY29tghljbi5pZW9ubGluZS5taWNyb3NvZnQuY29tghEqLm9yaWdpbi5iaW5nLmNvbYINKi5tbS5iaW5nLm5ldIIOKi5hcGkuYmluZy5jb22CGGVjbi5kZXYudmlydHVhbGVhcnRoLm5ldIINKi5jbi5iaW5nLm5ldIINKi5jbi5iaW5nLmNvbYIQc3NsLWFwaS5iaW5nLmNvbYIQc3NsLWFwaS5iaW5nLm5ldIIOKi5hcGkuYmluZy5uZXSCDiouYmluZ2FwaXMuY29tgg9iaW5nc2FuZGJveC5jb22CFmZlZWRiYWNrLm1pY3Jvc29mdC5jb22CG2luc2VydG1lZGlhLmJpbmcub2ZmaWNlLm5ldIIOci5iYXQuYmluZy5jb22CECouci5iYXQuYmluZy5jb22CEiouZGljdC5iaW5nLmNvbS5jboIPKi5kaWN0LmJpbmcuY29tgg4qLnNzbC5iaW5nLmNvbYIQKi5hcHBleC5iaW5nLmNvbYIWKi5wbGF0Zm9ybS5jbi5iaW5nLmNvbYINd3AubS5iaW5nLmNvbYIMKi5tLmJpbmcuY29tgg9nbG9iYWwuYmluZy5jb22CEXdpbmRvd3NzZWFyY2guY29tgg5zZWFyY2gubXNuLmNvbYIRKi5iaW5nc2FuZGJveC5jb22CGSouYXBpLnRpbGVzLmRpdHUubGl2ZS5jb22CDyouZGl0dS5saXZlLmNvbYIYKi50MC50aWxlcy5kaXR1LmxpdmUuY29tghgqLnQxLnRpbGVzLmRpdHUubGl2ZS5jb22CGCoudDIudGlsZXMuZGl0dS5saXZlLmNvbYIYKi50My50aWxlcy5kaXR1LmxpdmUuY29tghUqLnRpbGVzLmRpdHUubGl2ZS5jb22CCzNkLmxpdmUuY29tghNhcGkuc2VhcmNoLmxpdmUuY29tghRiZXRhLnNlYXJjaC5saXZlLmNvbYIVY253ZWIuc2VhcmNoLmxpdmUuY29tggxkZXYubGl2ZS5jb22CDWRpdHUubGl2ZS5jb22CEWZhcmVjYXN0LmxpdmUuY29tgg5pbWFnZS5saXZlLmNvbYIPaW1hZ2VzLmxpdmUuY29tghFsb2NhbC5saXZlLmNvbS5hdYIUbG9jYWxzZWFyY2gubGl2ZS5jb22CFGxzNGQuc2VhcmNoLmxpdmUuY29tgg1tYWlsLmxpdmUuY29tghFtYXBpbmRpYS5saXZlLmNvbYIObG9jYWwubGl2ZS5jb22CDW1hcHMubGl2ZS5jb22CEG1hcHMubGl2ZS5jb20uYXWCD21pbmRpYS5saXZlLmNvbYINbmV3cy5saXZlLmNvbYIcb3JpZ2luLmNud2ViLnNlYXJjaC5saXZlLmNvbYIWcHJldmlldy5sb2NhbC5saXZlLmNvbYIPc2VhcmNoLmxpdmUuY29tghJ0ZXN0Lm1hcHMubGl2ZS5jb22CDnZpZGVvLmxpdmUuY29tgg92aWRlb3MubGl2ZS5jb22CFXZpcnR1YWxlYXJ0aC5saXZlLmNvbYIMd2FwLmxpdmUuY29tghJ3ZWJtYXN0ZXIubGl2ZS5jb22CE3dlYm1hc3RlcnMubGl2ZS5jb22CFXd3dy5sb2NhbC5saXZlLmNvbS5hdYIUd3d3Lm1hcHMubGl2ZS5jb20uYXUwgbAGA1UdHwSBqDCBpTCBoqCBn6CBnIZNaHR0cDovL21zY3JsLm1pY3Jvc29mdC5jb20vcGtpL21zY29ycC9jcmwvTWljcm9zb2Z0JTIwUlNBJTIwVExTJTIwQ0ElMjAwMS5jcmyGS2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvbXNjb3JwL2NybC9NaWNyb3NvZnQlMjBSU0ElMjBUTFMlMjBDQSUyMDAxLmNybDBXBgNVHSAEUDBOMEIGCSsGAQQBgjcqATA1MDMGCCsGAQUFBwIBFidodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL21zY29ycC9jcHMwCAYGZ4EMAQIBMB8GA1UdIwQYMBaAFLV2DDARzseSQk1Mx1wsyKkM6AtkMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjANBgkqhkiG9w0BAQsFAAOCAgEAco89TAB1sCvQLroHS/xq5X+7QOIEa3+BQDho6pdRfQ4W1sgBJPJE9oe84V3ibTME8bAGsURyu1SSFZ++JPFkcdggIR155kU8dZEjRDPAlwcEYX8AkZJnCE1HW8x1asVMF978B9cyq35tgS9UPQu9j0bR1cbLZC8CzmnMVgUYjex/tZqcv0d1M+c2pIMTTl3SJQ8h6gE2YyWhQRdj3WxqyJKxVQOeGLN4g0GKm2iTfaXPAN3A7L0Okgl4JCI/VQTz/tTaG/f9mM3+vgtY9QIQKC0Swx5abPTMJW6YJiK8QoiM98L+e+xvuVHmcG2DWjeph1515z/kb+zXrHjUGsr3rwuEXSWGFFmzwzYdSZLSGwAucUskg8dKkU9OpAPmGA0dXfLbL9imaw/50PhLDo6XrEBjQUihArxDRRGEd7YGBU0W08povMRIE6tbxQZJsXREWlACD/SBlSx5pAmE7feAS7T82HrH4jm08/07zAnyh9WNqQH5flBjvHHHN9oCfP6/q9LcSqSx2KLskGfpaCq7RQpaYKhj9wVdHWnfAUcMTiiQgTl2heWLtfEbIUDfIGSg9oSdjpP8bxRgTcISZEcGeJLfJWqMJclDiseusW9mAqs0NY0/VvXmyjnL2eZ2ZKVj0GlyGE1bYkFlXlJ1DbRLrg7xJ+kl9iT/nv84uN+lfgg=
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
