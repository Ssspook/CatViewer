import SwiftUI

struct ReusableCatCell: View {
    @StateObject private var catViewModel: CatViewModel
    private var UIConstants = Constants.UIParameters.self
    
    init(_ catViewModel: CatViewModel) {
        _catViewModel = StateObject(wrappedValue: catViewModel)
    }
    
    // In order to calculate dynamic width only once
    var dynamicWidth: CGFloat {
        let width = Float(catViewModel.width)
        let height = Float(catViewModel.height)
        
        return CGFloat(width / height) * UIConstants.baseHeight
    }
    
    var body: some View {
        HStack(spacing: UIConstants.spacingBetweenViewElements) {
            
            if let data = ImageCache.shared.getData(for: catViewModel.url),
               let image = UIImage(data: data) {
                
                Image(uiImage: image)
                    .resizable()
                    .frame(width: dynamicWidth, height: UIConstants.baseHeight)
                
            } else if catViewModel.displayErrorPicture == true {
                Image("ErrorPicture")
                    .resizable()
                    .frame(width: UIConstants.baseWidth,
                           height: UIConstants.baseHeight)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(width: dynamicWidth, height: UIConstants.baseHeight)
            }
            
            VStack {
                Text("Width: \(catViewModel.width)")
                Text("Height: \(catViewModel.height)")
            }
            
            Spacer()
        }
    }
}

struct ReusableCatCell_Previews: PreviewProvider {
    static var previews: some View {
        ReusableCatCell(CatViewModel(cat: Cat(breeds: nil, id: "2345", url: "https://cdn2.thecatapi.com/images/Vijss-2-3.png", width: 600, height: 600), networker: NetworkManager(numberOfCats: 1)))
    }
}
