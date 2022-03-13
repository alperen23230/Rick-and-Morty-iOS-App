//
//  RickAndMortyWidget.swift
//  RickAndMortyWidget
//
//  Created by Alperen Ünal on 18.04.2021.
//

import WidgetKit
import SwiftUI

struct CharacterEntry: TimelineEntry {
    
    let date: Date
    let character: RickAndMortyCharacter
    let characterImage: UIImage
    
    var relevance: TimelineEntryRelevance? {
        return TimelineEntryRelevance(score: 50)
    }
    
}

struct Provider: TimelineProvider {
    
    let imageStore = ImageStore()
    
    func getSnapshot(in context: Context, completion: @escaping (CharacterEntry) -> Void) {
        completion(CharacterEntry(date: Date(), character: RickAndMortyCharacter(id: 1, name: "asd", status: .dead, species: "", gender: "", imageUrl: "", created: Date()), characterImage: UIImage()))
    }
    
    func placeholder(in context: Context) -> CharacterEntry {
        return CharacterEntry(date: Date(), character: RickAndMortyCharacter(id: 1, name: "asd", status: .dead, species: "", gender: "", imageUrl: "", created: Date()), characterImage: UIImage())
    }
    
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CharacterEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .second, value: 10, to: currentDate)!
        
        URLSession.shared.dataTask(with: Endpoint.getCharacters(name: "", status: "", gender: "", page: 1).url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else { return }
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            guard let data = data else { return }
            guard let characterData = try? decoder.decode(GeneralAPIResponse<RickAndMortyCharacter>.self, from: data) else { return }
            guard let randomCharacter = characterData.results.randomElement() else { return }
            if let image = imageStore.retrieveImage(forKey: randomCharacter.imageUrl) {
                // Image from cache
                let entry = CharacterEntry(date: currentDate, character: randomCharacter, characterImage: image)
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
            } else {
                // Image from network call
                getCharacterImageFromNetwork(urlString: randomCharacter.imageUrl) { image in
                    let entry = CharacterEntry(date: currentDate, character: randomCharacter, characterImage: image)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                }
            }
        }
        .resume()
        
    }
    
    func getCharacterImageFromNetwork(urlString: String, completion: @escaping (UIImage) -> ()) {
        guard let url = URL(string: urlString) else { completion(UIImage());return }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                imageStore.saveImage(image, forKey: urlString)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                completion(UIImage())
            }
        }
    }
    
}

struct WidgetEntryView: View {
    
    let entry: Provider.Entry
    
    var body: some View {
        VStack(spacing: 5) {
            Image(uiImage: entry.characterImage)
                .resizable()
            Text(entry.character.name)
                .font(.system(.body))
                .foregroundColor(Color(UIColor.rickBlue))
                .padding(5)
        }
    }
}

@main
struct MyWidget: Widget {
    private let kind = "My_Widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { (entry) in
            WidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
    }
}
