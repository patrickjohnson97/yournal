//
//  Background.swift
//  yournal
//
//  Created by Patrick Johnson on 3/22/21.
//

import SwiftUI

struct Background: View {
    @AppStorage("user.theme") var theme: String = "Parchment"
    var body: some View {
        Rectangle().edgesIgnoringSafeArea(.all).foregroundColor(getThemeColor(name: "Background", theme: theme))
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background()
    }
}
