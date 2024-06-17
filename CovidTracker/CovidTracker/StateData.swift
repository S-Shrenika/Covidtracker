import Foundation

struct State: Codable {
    let state: String
    let name: String
}
import Foundation

class StateDataFetcher {
    static let shared = StateDataFetcher()
    
    func fetchStates(completion: @escaping ([State]?) -> Void) {
        guard let url = URL(string: "https://api.covidtracking.com/v1/states/info.json") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let states = try JSONDecoder().decode([State].self, from: data)
                    DispatchQueue.main.async {
                        completion(states)
                    }
                } catch {
                    print("Error decoding states: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}

