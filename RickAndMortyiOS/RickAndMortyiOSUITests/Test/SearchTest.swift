import XCTest

class SearchTest: XCTestCase {
    
    func testSearchCharacters() {
        let app = XCUIApplication()
        app.launch()
        
        Page(app).on(view: CharactersPage.self).search("Annie")
            .on(view: CharactersPage.self).checkHasResult(characterName: "Annie")
    }
}
