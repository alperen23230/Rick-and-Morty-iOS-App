import XCTest

class CharactersPage: Page {
    private lazy var searchField = app.searchFields.firstMatch
    private lazy var characterCells = app.cells.containing(NSPredicate(format: "identifier MATCHES %@", "characterName"))
    
    required init(_ app: XCUIApplication) {
        super.init(app)
        waitUntil(element: characterCells.firstMatch, condition: .exist)
    }
    
    @discardableResult
    func checkHasResult(characterName: String) -> Self {
        let cell = characterCells.staticTexts.matching(NSPredicate(format: "identifier MATCHES %@ AND label CONTAINS %@", "characterName", characterName)).firstMatch
        
        waitUntil(element: cell, condition: .exist)
        
        return self
    }
    
    @discardableResult
    func openCharacterDetail(position: Int) -> CharacterDetailPage {
        let cell = characterCells.element(boundBy: position).firstMatch
        
        tap(element: cell)
        
        return CharacterDetailPage(app)
    }
    
    @discardableResult
    func search(_ character: String) -> Self {
        typeText(element: searchField, input: character)
        
        return self
    }
}
