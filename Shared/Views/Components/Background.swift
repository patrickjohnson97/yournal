//
//  Background.swift
//  yournal
//
//  Created by Patrick Johnson on 3/22/21.
//

import SwiftUI

struct Background: View {
    var body: some View {
        Rectangle().edgesIgnoringSafeArea(.all).foregroundColor(Color("Background"))
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background()
    }
}
