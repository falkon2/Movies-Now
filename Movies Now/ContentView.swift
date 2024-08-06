import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.movies.isEmpty {
                    Text("No movies available.")
                        .font(.headline)
                } else {
                    List(viewModel.movies) { movie in
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.headline)
                            // Optionally display other details like a poster image
                        }
                    }
                }
            }
            .navigationTitle("Movies")
            .onAppear {
                viewModel.fetchMovies()
            }
        }
    }
}

#Preview {
    ContentView()
}
