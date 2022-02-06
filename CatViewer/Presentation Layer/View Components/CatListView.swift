import SwiftUI

struct CatListView: View {
    @StateObject private var catsListViewModel = CatsListViewModel(networker: NetworkManager(numberOfCats: Constants.Network.numberOfCats))
    private var UIConstants = Constants.UIParameters.self
    
    var body: some View {
        
        NavigationView {
            VStack {
                List(catsListViewModel.cats) { cat in
                    NavigationLink(destination: DetailedCatView(cat)) {
                        ReusableCatCell(cat)
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: UIConstants.cornerRadius).strokeBorder(.pink))
                    .mask(RoundedRectangle(cornerRadius: UIConstants.cornerRadius))
                }
                .navigationTitle(Text("Cats"))
                .alert(catsListViewModel.alertHeader, isPresented: $catsListViewModel.showAlert, actions: {}, message: {
                    Text(catsListViewModel.alertMessage)
                })
                
                MoreButton(catsListViewModel)
            }
        }
        .onAppear(perform: {
            catsListViewModel.fetchCatsIfNeeded()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CatListView()
    }
}
