import Foundation

struct CovidData: Codable {
    let date: Int
    let positiveIncrease: Int
    let negativeIncrease: Int
    let deathIncrease: Int
    let hospitalizedIncrease: Int
}

class CovidDataFetcher {
    static let shared = CovidDataFetcher()
    
    func fetchCovidData(for state: String, completion: @escaping ([CovidData]?) -> Void) {
        guard let url = URL(string: "https://api.covidtracking.com/v1/states/\(state.lowercased())/daily.json") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([CovidData].self, from: data)
                    let sortedData = decodedData.sorted { $0.date > $1.date }
                    DispatchQueue.main.async {
                        completion(sortedData)
                    }
                } catch {
                    print("Error decoding data: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}
