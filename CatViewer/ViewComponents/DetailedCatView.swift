import SwiftUI

struct DetailedCatView: View {
    @StateObject private var catViewModel: CatViewModel
    
    init(_ catViewModel: CatViewModel) {
        _catViewModel = StateObject(wrappedValue: catViewModel)
    }
    
    var body: some View {
        VStack {
            if let data = ImageCache.shared.getData(for: catViewModel.url),
               let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView().progressViewStyle(.circular)
                    .onAppear(perform: catViewModel.fetchImage)
            }

            ScrollView {
                Text(catViewModel.jsonPrettyString)
            }
        }
    }
}

struct DetailedCatView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedCatView(CatViewModel(cat: Cat(breeds: nil, id: "fdfdd", url: "https://cdn2.thecatapi.com/images/Vijss-2-3.png", width: 600, height: 600), networker: NetworkManager(numberOfCats: 1)))
    }
}
