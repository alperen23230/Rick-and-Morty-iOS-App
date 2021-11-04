import XCTest

class NavigateTest: XCTestCase {
    
    func testViewCharacterDetailAndBack() {
        let app = XCUIApplication()
        app.launch()
        
        Page(app).on(view: CharactersPage.self).openCharacterDetail(position: 0)
            .on(view: CharacterDetailPage.self).back()
            .on(view: CharactersPage.self)
    }
}
