//
//  ContentView.swift
//  DynamicPanel
//
//  Created by Tema Sysoev on 22.02.2021.
//

import SwiftUI
struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .prominent
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
struct ContentView: View {
    @State private var expand = true
    @State private var offsetExpanded = CGSize(width: 0, height: .zero)
    @State private var offsetSmall = CGSize(width: 0, height: 1000)
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color(UIColor.systemOrange))
                        .opacity(0.0)
                    
                    HStack(){
                        
                        Button(action: {
                            expand = false
                            self.offsetExpanded = CGSize(width: 1000, height: 0)
                            
                            let impactMed = UIImpactFeedbackGenerator(style: .light)
                            impactMed.impactOccurred()
                        })
                        {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .opacity(0.0)
                                    .frame(width: 40, height: 40)
                                Image(systemName: "chevron.compact.right")
                                    .foregroundColor(Color(UIColor.systemGray5))
                                
                            }
                            
                        }
                        
                        Spacer()
                    }
                    
                }
                .background(Blur())
                .frame(width: 250, height: 60)
                .cornerRadius(20)
                
                
            }
            
            .offset(x: self.offsetExpanded.width, y: -30.0)
            
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if abs(gesture.translation.width) < 30 {
                            self.offsetExpanded = gesture.translation
                        }
                        else{
                            self.offsetExpanded.width = gesture.translation.width/3
                        }
                        
                    }
                    
                    .onEnded { _ in
                        if self.offsetExpanded.width > 30 {
                            self.offsetExpanded.width = 1000
                            expand = false
                            let impactMed = UIImpactFeedbackGenerator(style: .light)
                            impactMed.impactOccurred()
                        } else {
                            
                            self.offsetExpanded = .zero
                        }
                    }
            )
            
            VStack{
                Spacer()
                if !expand{
                    HStack{
                        Spacer()
                        ZStack{
                            
                            Button(action: {
                                expand = true
                                self.offsetExpanded = .zero
                                let impactMed = UIImpactFeedbackGenerator(style: .soft)
                                impactMed.impactOccurred()
                            })
                            {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(Color(UIColor.systemOrange))
                                        .opacity(0.0)
                                        .frame(width: 25, height: 60)
                                    
                                    
                                }
                                
                            }
                        }
                        .background(Blur())
                        .cornerRadius(20)
                        
                    }
                    
                    
                    .offset(x: self.offsetSmall.width, y: -30)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if abs(gesture.translation.width) < 30 {
                                    self.offsetSmall = gesture.translation
                                }
                                else{
                                    self.offsetSmall.width = gesture.translation.width/self.offsetSmall.width
                                }
                                
                            }
                            
                            .onEnded { _ in
                                if abs(self.offsetSmall.width) > 10 {
                                    self.offsetExpanded.width = 1000
                                    expand = true
                                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                                    impactMed.impactOccurred()
                                } else {
                                    expand = false
                                    let impactMed = UIImpactFeedbackGenerator(style: .light)
                                    impactMed.impactOccurred()
                                    self.offsetSmall = .zero
                                }
                            }
                    )
                    
                    .ignoresSafeArea()
                }
            }
        }
        
        .shadow(color: Color(UIColor.systemGray4).opacity(0.9), radius: 6, x: 0, y: 0)
        .ignoresSafeArea()
        .animation(.spring())
        .padding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
