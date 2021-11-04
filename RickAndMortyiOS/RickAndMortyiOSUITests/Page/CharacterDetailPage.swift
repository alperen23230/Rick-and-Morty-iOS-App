import XCTest

class CharacterDetailPage: Page {
    private lazy var backButton = app.navigationBars.buttons["Characters"].firstMatch
    private lazy var speciesText = app.staticTexts["characterSpecies"].firstMatch
    
    required init(_ app: XCUIApplication) {
        super.init(app)
        waitUntil(element: speciesText, condition: .exist)
    }
    
    func back() -> CharactersPage {
        tap(element: backButton)
        
        return CharactersPage(app)
    }
}
