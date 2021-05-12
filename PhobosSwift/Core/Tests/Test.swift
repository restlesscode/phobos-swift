//
//  Bundle.swift
//  CodebaseCore
//
//  Created by Theo Chen on 2019/4/18.
//
import Foundation
import CodebaseCore
import XCTest

/// Test the enhanced features of Bundle class is implemented in this extension
class Test: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBundle_forMainBundle() {
        let currentBundle = Bundle.cob_bundle(with:CodebaseCore.self)
        XCTAssertNotNil(currentBundle.bundlePath)
        XCTAssertNotNil(currentBundle.resourcePath)
        XCTAssertNotNil(currentBundle.executablePath)
    }
    
    func testStringRegex() {
        XCTAssertTrue("03323@smail.tongji.edu.cn".cob_isText(ofRegexTypes: .email), "Email regex passed")
        XCTAssertTrue("theo.chen@me.7zip".cob_isText(ofRegexTypes: .email), "Email regex passed")
        XCTAssertTrue("13148469712".cob_isText(ofRegexTypes: .chineseMobileNumber), "Chinese mobile number regex passed")
        XCTAssertTrue("18273213211231213213".cob_isText(ofRegexTypes: .digit), "Digital regex passed")
        XCTAssertTrue("世上只有妈妈好".cob_isText(ofRegexTypes: .chineseCharacter), "Chinese regex passed")
        XCTAssertFalse("世上只 有妈妈 好".cob_isText(ofRegexTypes: .chineseCharacter), "Chinese with space regex NOT passed")
        XCTAssertTrue("IloveiOS".cob_isText(ofRegexTypes: .englishLetter), "English Letters regex passed")
        XCTAssertFalse("I love iOS".cob_isText(ofRegexTypes: .englishLetter), "English Letters with space regex NOT passed")
        XCTAssertTrue("Ilove88912321iOS".cob_isText(ofRegexTypes: [.englishLetter, .digit]), "English Letters and digits regex passed")
        XCTAssertTrue("Ilove88912321iOS".cob_isText(ofRegexTypes: [.englishLetter, .digit]), "English Letters and digits regex passed")
        XCTAssertTrue("真光路1433弄5号1111室A座".cob_isText(ofRegexTypes: [.englishLetter, .digit, .chineseCharacter]), "English Letters, Chinese characters and digits regex passed")
        
        XCTAssertFalse("真光路1433弄5号1111室A😊座".cob_isText(ofRegexTypes: [.englishLetter, .digit, .chineseCharacter]), "emoji not passed")
        XCTAssertTrue("德国保时捷（上海）销售有限公司".cob_isText(ofRegexTypes: [.chineseCharacter, .englishLetter, .digit, .punctuation]), "Company Title passed")
    }
}


