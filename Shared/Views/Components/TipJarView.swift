//
//  TipJarView.swift
//  yournal
//
//  Created by Patrick Johnson on 4/13/21.
//

import SwiftUI
import Purchases
import AlertToast
import ConfettiSwiftUI
struct TipJarView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var iapManager = IAPManager()
    @AppStorage("user.theme") var theme: String = "Parchment"
    @State var showConfetti = false
    let tips: [Tip] = [Tip(name: "Coffee", price: 0.99), Tip(name: "Soup", price: 4.99), Tip(name: "Pizza", price: 4.99)]
    var body: some View {
        ZStack{
            Background()
            VStack(alignment: .leading){
                HStack{
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.down")
                    })
                    .buttonStyle(GenericButtonStyle(foregroundColor: .accentColor, backgroundColor: Color.accentColor.opacity(0.14), pressedColor: Color.accentColor.opacity(0.2), internalPadding: 10))
                }
                Text("Tip Jar").font(.largeTitle).bold()
                Divider()
                ScrollView{
                    Text("Hey there👋, \n\nI'll be honest with you - I'm just one guy. This isn't even my day job. I love this app, and if you do too - support it ((and me😉))!\n\nBest regards,\nPatrick Johnson").font(.system(.headline, design: .serif))
                    Divider()
                    //            HStack{
                    //                Spacer()
                    ForEach(iapManager.packages, id: \.self){ package in
                        TipButton(iapManager: iapManager, package: package)
                        //                    Spacer()
                        //                }
                    }
                    Spacer()
                    
                }
            }.padding()
            ConfettiCannon(counter: $iapManager.purchasedItemCounter)
        }
        .accentColor(getThemeColor(name: "Inferred", theme: theme))
        .toast(isPresenting: $iapManager.inPaymentProgress, alert: {
            AlertToast(displayMode: .alert, type: .loading)
        })
        .toast(isPresenting: $iapManager.purchasedItem, duration: 4.0, tapToDismiss: true, alert: {
            AlertToast(displayMode: .alert, type: .complete(getThemeColor(name: "Inferred", theme: theme)), title: "Tip Received" , subTitle: "Thank you for your support🙏")
        }, completion: {_ in
            iapManager.purchasedItem = false
        })
        
        
    }
}

struct Tip: Identifiable{
    var id = UUID()
    var name: String
    var price: Double
}

struct TipJarView_Previews: PreviewProvider {
    static var previews: some View {
        TipJarView()
    }
}

struct TipButton: View {
    @ObservedObject var iapManager: IAPManager
    var package: Purchases.Package
    @AppStorage("user.theme") var theme: String = "Parchment"
    var body: some View {
        
        Button(action: {
            iapManager.purchase(product: package)
        }
        , label: {
            HStack{
                VStack(alignment: .leading){
                    Text("\(package.product.localizedTitle)").font(.caption).bold()
                    Text("\(package.product.localizedDescription)").font(.caption2)
                }
                Spacer()
                Text(package.localizedPriceString)
                    .foregroundColor(getThemeColor(name: "Background", theme: theme)).bold()
                    .padding(7)
                    .background(RoundedRectangle(cornerRadius: 8).foregroundColor(getThemeColor(name: "Chosen", theme: theme)))
            }
            
        })
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).foregroundColor(getThemeColor(name: "Card", theme: theme)))
    }
}


prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
