//
//  LoadingView.swift
//  NYCSchools
//
//  Created by Gustavo Halperin on 8/8/22.
//

import SwiftUI


struct ActivityIndicator: View {
    @State var dots = 0
    let timer = Timer.publish(every: 0.5,
                              on: .main,
                              in: .common)
        .autoconnect()
    var body: some View {
        Text(loading)
            .font(.system(.body, design: .monospaced)).bold()
            .transition(.slide)
            .onReceive(timer) { _ in
                dots = dots >= 3 ? 0 : dots + 1
            }
    }
    var loading: String {
        if dots == 0 { return "Loading    "}
        if dots == 1 { return "Loading .  "}
        if dots == 2 { return "Loading .. "}
        return "Loading ..."
    }
}

struct LoadingView<Content>: View where Content: View {
    let isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                content()
                    .disabled(isShowing)
                    .blur(radius:isShowing ? 3 : 0)
                HStack {
                    Spacer()
                    VStack {
                        ActivityIndicator()
                    }
                    .frame(width: geometry.size.width / 2,
                           height: geometry.size.height / 5)
                    .background(Color.secondary.colorInvert())
                    .foregroundColor(Color.primary)
                    .cornerRadius(20)
                    .opacity(isShowing ? 0.65 : 0)
                    Spacer()
                }
            }
        }
    }

}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isShowing: true) {
            VStack {
                Text("Hello")
                Spacer()
            }
        }
    }
}
