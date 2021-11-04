import XCTest
import Foundation

enum elementStatus: String {
    case exist = "exists == true"
    case notExist = "exists == false"
}

class Page {
    var app: XCUIApplication
    
    required init(_ app: XCUIApplication) {
        self.app = app
    }
    
    @discardableResult
    func on<T: Page>(view: T.Type) -> T {
        let nextPage: T
        
        if self is T {
            nextPage = self as! T
        } else {
            nextPage = view.init(app)
        }
        
        return nextPage
    }
    
    func waitUntil(element: XCUIElement, condition: elementStatus, timeout: TimeInterval = TimeInterval.init(5)) {
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: condition.rawValue), object: element)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        
        if result == .timedOut {
            XCTFail(expectation.description)
        }
    }
    
    func tap(element: XCUIElement) {
        waitUntil(element: element, condition: .exist)
        element.tap()
    }
    
    func typeText(element: XCUIElement, input: String) {
        waitUntil(element: element, condition: .exist)
        
        element.tap()
        element.typeText(input)
    }
}
