import SwiftUI

struct CatListView: View {
    @StateObject private var catsListViewModel = CatsListViewModel(networkManager: NetworkManager(numberOfCats: 10))
    
    var body: some View {
   
        NavigationView {
            
            List(catsListViewModel.cats) { cat in
                NavigationLink(destination: DetailedCatView(cat)) {
                    ReusableCatCell(cat)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(.pink))
                .mask(RoundedRectangle(cornerRadius: 16))
                .onAppear {
                    if self.catsListViewModel.cats.last == cat {
                        catsListViewModel.fetchCats()
                    }
                }
            }
            .navigationTitle(Text("Cats"))
            .onAppear(perform: catsListViewModel.fetchCats)
            .alert(catsListViewModel.error?.name ?? "Error", isPresented: $catsListViewModel.showAlert, actions: {}, message: {
                Text(catsListViewModel.error?.description ?? "Error occured")
            })
            .refreshable {
                catsListViewModel.fetchCats()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CatListView()
    }
}
