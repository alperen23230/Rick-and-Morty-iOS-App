import XCTest

class TabBar: Page {
    private lazy var charactersTab = app.tabs["Characters"].firstMatch
    
    required init(_ app: XCUIApplication) {
        super.init(app)
        waitUntil(element: charactersTab, condition: .exist)
    }
}
