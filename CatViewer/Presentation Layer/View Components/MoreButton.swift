//
//  MoreButton.swift
//  CatViewer
//
//  Created by Meritocrat on 1/26/22.
//

import SwiftUI

struct MoreButton: View {
    private var catsListViewModel: CatsListViewModel
    
    init(_ catsListViewModel: CatsListViewModel) {
        self.catsListViewModel = catsListViewModel
    }
    
    var body: some View {
        Button {
            catsListViewModel.fetchCats()
        } label: {
            Text("More")
                .foregroundColor(.indigo)
                .frame(width: Constants.buttonWidth,
                       height: Constants.baseHeight,
                       alignment: .center)
                .overlay(RoundedRectangle(cornerRadius: Constants.cornerRadius).strokeBorder(.pink))
                .mask(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
    }
}

struct MoreButton_Previews: PreviewProvider {
    static var previews: some View {
        MoreButton(CatsListViewModel(networker: NetworkManager(numberOfCats: 1)))
    }
}
