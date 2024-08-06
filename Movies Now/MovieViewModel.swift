import Foundation
import Combine

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let poster: String
    // Add other properties based on your API response
}

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    
    private let apiKey = "ed5aaa7773msh3b14c34c2c728f0p1a7e22jsn6cb28c93c2c1" // Replace with your actual API key
    private let apiHost = "streaming-availability.p.rapidapi.com"
    
    func fetchMovies() {
        // Replace the title and country as needed
        let title = "The Godfather"
        let country = "us"
        
        guard var urlComponents = URLComponents(string: "https://streaming-availability.p.rapidapi.com/shows/search/title") else { return }
        
        // Set query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "title", value: title),
            URLQueryItem(name: "country", value: country)
        ]
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(apiHost, forHTTPHeaderField: "x-rapidapi-host")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            // Debug print statement to inspect the raw JSON response
            let jsonString = String(data: data, encoding: .utf8)
            print("Response JSON: \(jsonString ?? "No Data")")
            
            do {
                // Decode the JSON response
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let message = jsonResponse?["message"] as? String {
                    print("Error Message: \(message)")
                } else {
                    // Check for results and parse them
                    if let results = jsonResponse?["results"] as? [[String: Any]] {
                        let jsonData = try JSONSerialization.data(withJSONObject: results)
                        let decodedResponse = try JSONDecoder().decode([Movie].self, from: jsonData)
                        DispatchQueue.main.async {
                            self.movies = decodedResponse
                        }
                    } else {
                        print("No results found.")
                    }
                }
            } catch let decodingError {
                print("Decoding Error: \(decodingError)")
            }
        }
        
        dataTask.resume()
    }
}
