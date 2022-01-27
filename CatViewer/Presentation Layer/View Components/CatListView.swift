import SwiftUI

struct CatListView: View {
    @StateObject private var catsListViewModel = CatsListViewModel(networker: NetworkManager(numberOfCats: Constants.numberOfCats))
    
    var body: some View {
        
        NavigationView {
            List(catsListViewModel.cats) { cat in
                NavigationLink(destination: DetailedCatView(cat)) {
                    ReusableCatCell(cat)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: Constants.cornerRadius).strokeBorder(.pink))
                .mask(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            }
            .navigationTitle(Text("Cats"))
            .onAppear(perform: {
                if catsListViewModel.cats.count == 0 {
                    catsListViewModel.fetchCats()
                }
            })
            .alert(catsListViewModel.error?.name ?? "Error", isPresented: $catsListViewModel.showAlert, actions: {}, message: {
                Text(catsListViewModel.error?.description ?? "Error occured")
            })
        }
        .onAppear {
            URLCache.shared.memoryCapacity = 1024 * 1024 * 512
        }
        
        MoreButton(catsListViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CatListView()
    }
}
