//
//  MoreButton.swift
//  CatViewer
//
//  Created by Meritocrat on 1/26/22.
//

import SwiftUI

struct MoreButton: View {
    private var catsListViewModel: CatsListViewModel
    private var UIConstants = Constants.UIParameters.self
    
    init(_ catsListViewModel: CatsListViewModel) {
        self.catsListViewModel = catsListViewModel
    }
    
    var body: some View {
        Button {
            catsListViewModel.fetchCatsIfNeeded()
        } label: {
            Text("More")
                .foregroundColor(.indigo)
                .frame(width: UIConstants.buttonWidth,
                       height: UIConstants.baseHeight,
                       alignment: .center)
                .overlay(RoundedRectangle(cornerRadius: UIConstants.cornerRadius).strokeBorder(.pink))
                .mask(RoundedRectangle(cornerRadius: UIConstants.cornerRadius))
        }
    }
}

struct MoreButton_Previews: PreviewProvider {
    static var previews: some View {
        MoreButton(CatsListViewModel(networker: NetworkManager(numberOfCats: 1)))
    }
}
