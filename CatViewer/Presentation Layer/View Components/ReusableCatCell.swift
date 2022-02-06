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
              // .baseHeight is CGFloat. so you convert it to Float and then convert back to CGFloat... width/height can be move to calculated once as i.e. ratio variable. it makes next line more readable))
//              JFYI You should understand that this view's body will be called each time as catViewModel publishes any changes
                    .frame(width: CGFloat(Float(catViewModel.width) / Float(catViewModel.height) * Float(Constants.baseHeight)),
                           height: Constants.baseHeight)
                
            } else if catViewModel.displayErrorPicture == true {
                Image("ErrorPicture")
                    .resizable()
              // seems like 50 is a baseHeight. literals.. again
                    .frame(width: 50, height: 50)
            } else {
              // this view has no height. That's why after progress view size changed ("jumped")...
                ProgressView().progressViewStyle(.circular)
            }
            
            VStack {
                Text("Width: \(catViewModel.width)")
                Text("Height: \(catViewModel.height)")
            }
            
            Spacer()
        }
      // what for? 
        .frame(maxWidth: .infinity)
    }
}

struct ReusableCatCell_Previews: PreviewProvider {
    static var previews: some View {
        ReusableCatCell(CatViewModel(cat: Cat(breeds: nil, id: "2345", url: "https://cdn2.thecatapi.com/images/Vijss-2-3.png", width: 600, height: 600), networker: NetworkManager(numberOfCats: 1)))
    }
}
