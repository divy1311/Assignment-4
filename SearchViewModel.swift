//
//  SearchViewModel.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/12/24.
//

import SwiftUI

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var results: [SearchResult] = []
    var cancellables = Set<AnyCancellable>()
    @Published var isSearching = false
    
    init() {
        $searchTerm
           .removeDuplicates()
           .debounce(for: 0.5, scheduler: RunLoop.main)
           .sink { [weak self] term in
               guard let self = self else { return }
               DispatchQueue.main.async {
                   self.isSearching = !term.isEmpty
               }
               self.fetchResults(for: term)
           }
           .store(in: &cancellables)
    }
    
    func fetchResults(for query: String) {
        guard !query.isEmpty, let url = URL(string: "http://127.0.0.1:3000/company/names?ticker=\(query)") else {
            self.results = []
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            let decodedResponse = try? JSONDecoder().decode([SearchResult].self, from: data)
            DispatchQueue.main.async {
                self?.results = decodedResponse ?? []
            }
        }.resume()
    }
}


#Preview {
    SearchViewModel() as! any View
}
