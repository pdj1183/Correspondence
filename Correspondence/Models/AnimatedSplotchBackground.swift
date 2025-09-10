//
//  AnimatedSplotchBackground.swift
//  Correspondence
//
//  Created by Phillip Johnson on 8/29/25.
//


import SwiftUI

struct AnimatedSplotchBackground: View {
    @State private var move1 = false
    @State private var move2 = false
    @State private var move3 = false

    var body: some View {
//        TimelineView(.animation) { _ in
            ZStack {
                // Base
                Color.black.ignoresSafeArea()

                // Purple splotch
                RadialGradient(
                    gradient: Gradient(colors: [Color.purpleBackground, .clear]),
                    center: move1 ? .topLeading : .bottomTrailing,
                    startRadius: 180,
                    endRadius: 900
                )
                .animation(.easeInOut(duration: 16).repeatForever(autoreverses: true), value: move1)

                // Slate blue splotch
                RadialGradient(
                    gradient: Gradient(colors: [Color.greenBackground, .clear]),
                    center: move2 ? .topTrailing : .bottomLeading,
                    startRadius: 200,
                    endRadius: 900
                )
                .animation(.easeInOut(duration: 20).repeatForever(autoreverses: true), value: move2)

            }
 //           .onAppear {
 //               move1.toggle()
 //               move2.toggle()
 //               move3.toggle()
//            }
//        }
    }
}

#Preview {
    AnimatedSplotchBackground()
        .frame(width: 1000, height: 1000)
}
