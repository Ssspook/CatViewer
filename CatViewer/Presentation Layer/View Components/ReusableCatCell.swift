import SwiftUI

struct ReusableCatCell: View {
    @StateObject private var catViewModel: CatViewModel
    
    init(_ catViewModel: CatViewModel) {
        _catViewModel = StateObject(wrappedValue: catViewModel)
    }
    
    var body: some View {
        HStack(spacing: Constants.spacingBetweenViewElements) {
            
            if let data = ImageCache.shared.getData(for: catViewModel.url),
               let image = UIImage(data: data) {
                
                Image(uiImage: image)
                    .resizable()
                    .frame(width: CGFloat(Float(catViewModel.width) / Float(catViewModel.height) * Float(Constants.baseHeight)),
                           height: Constants.baseHeight)
                
            } else if catViewModel.displayErrorPicture == true {
                Image("ErrorPicture")
                    .resizable()
                    .frame(width: 50, height: 50)
            } else {
                ProgressView().progressViewStyle(.circular)
            }
            
            VStack {
                Text("Width: \(catViewModel.width)")
                Text("Height: \(catViewModel.height)")
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct ReusableCatCell_Previews: PreviewProvider {
    static var previews: some View {
        ReusableCatCell(CatViewModel(cat: Cat(breeds: nil, id: "2345", url: "https://cdn2.thecatapi.com/images/Vijss-2-3.png", width: 600, height: 600), networker: NetworkManager(numberOfCats: 1)))
    }
}
