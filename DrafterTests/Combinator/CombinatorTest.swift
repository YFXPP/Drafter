//
//  TestCombinator.swift
//  DrafterTests
//
//  Created by LZephyr on 2017/11/1.
//

import XCTest

class CombinatorTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSeparator1() {
        let tokens: [Token] = [Token(type: .name, text: "name1"),
                               Token(type: .comma, text: ","),
                               Token(type: .name, text: "name2"),
                               Token(type: .comma, text: ",")]
        let comma = token(.comma)
        let parser = token(.name).separateBy(comma)
        
        if case .failure(_) = parser.parse(tokens) {
            XCTAssert(false)
        }
    }
    
    func testSeparator2() {
        let tokens: [Token] = [Token(type: .name, text: "name1")]
        let comma = token(.comma)
        let parser = token(.name).separateBy(comma)
        
        guard case .success(let (result, rest)) = parser.parse(tokens) else {
            XCTAssert(false)
            return
        }
        XCTAssert(result.count == 2)
        XCTAssert(rest.count == 0)
    }

    func testBetween() {
        let tokens: [Token] = [Token(type: .leftBrace, text: "{"),
                               Token(type: .name, text: "name"),
                               Token(type: .rightBrace, text: "}")]
        let parser = token(.name).between(token(.leftBrace), token(.rightBrace))
        guard case .success(let (result, rest)) = parser.parse(tokens) else {
            XCTAssert(false)
            return
        }
        
        XCTAssert(result.type == .name)
        XCTAssert(result.text == "name")
        XCTAssert(rest.count == 0)
    }
    
    func testMany() {
        let tokens: [Token] = [Token(type: .name, text: "name1"),
                               Token(type: .name, text: "name2")]
        guard case .success(let (result, rest)) = token(.name).many.parse(tokens) else {
            XCTAssert(false)
            return
        }
        
        XCTAssert(result.count == 2)
        XCTAssert(result[0].text == "name1")
        XCTAssert(result[1].text == "name2")
        XCTAssert(rest.count == 0)
    }
    
    func testAnyTokenUntil() {
        let tokens = [Token(type: .name, text: "name"),
                      Token(type: .comma, text: ","),
                      Token(type: .colon, text: ":")]
        guard case .success(let (result, rest)) = anyToken(until: { $0.type == .colon}).parse(tokens) else {
            XCTAssert(false)
            return
        }
        
        XCTAssert(result.count == 2)
        XCTAssert(rest.count == 1)
    }
    
    func testAnyTokenUntil2() {
        let tokens = [Token(type: .name, text: "name"),
                      Token(type: .comma, text: ","),
                      Token(type: .colon, text: ":")]
        guard case .success(let (result, rest)) = anyToken(until: token(.colon)).parse(tokens) else {
            XCTAssert(false)
            return
        }
        
        XCTAssert(result.count == 2)
        XCTAssert(rest.count == 1)
    }
    
    func testAnyTokenBetween() {
        let tokens = [Token(type: .leftParen, text: "("),
                      Token(type: .name, text: "name1"),
                      Token(type: .name, text: "name2"),
                      Token(type: .leftParen, text: "("),
                      Token(type: .rightParen, text: ")"),
                      Token(type: .rightParen, text: ")")]
        
        guard case .success(let (result, rest)) = anyToken(between: .leftParen, and: .rightParen).parse(tokens) else {
            XCTAssert(false)
            return
        }
        
        XCTAssert(result.count == 4)
        XCTAssert(rest.count == 0)
    }
}
