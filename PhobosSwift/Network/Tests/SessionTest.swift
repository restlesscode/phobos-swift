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
    testPublicKey()
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

  func testPublicKey() {
    describe("Given 在测试环境中") {
      context("When 调用Session.pbs.addPublicKey") {
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
        let session = Session.pbs.default
        session.pbs.addPublicKey(publicKey: pubKey)
        it("Then publicKeyEvaluator.keys 不为空") {
          if let serverTrustManager = session.serverTrustManager as? PBSPinner.ServerTrustManager {
            expect(!serverTrustManager.evaluator.publicKeyEvaluator.keys.isEmpty).to(beTrue())
          } else {
            expect(false).to(beTrue())
          }
        }
      }
    }
  }
}
