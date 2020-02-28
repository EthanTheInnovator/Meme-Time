//
//  ContentView.swift
//  MemeTime
//
//  Created by Ethan Humphrey on 10/30/19.
//  Copyright © 2019 Ethan Humphrey. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var memeImage: Image? = nil
    @State var finishedMemeImage: UIImage? = nil
    @State var imageAspectRatio: CGFloat = 0
    @State var showImagePicker = false
    @State var isGoodMemeFormat = true
    @State var showInputText = false
    @State var showMemeTypeAlert = false
    @State var topText = ""
    @State var bottomText = ""
    @State var memeRect: CGRect = .zero
    @State var shareMemePresented: Bool = false
    @State var darkMeme: Bool = false
    
    var body: some View {
        NavigationView {
                GeometryReader { metrics in
                    ScrollView {
                    VStack {
                        TextField("Top Text", text: self.$topText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 16)
                        if !self.isGoodMemeFormat {
                            TextField("Bottom Text", text: self.$bottomText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 16)
                        }
                        ZStack {
                            VStack(alignment: .leading, spacing: 0) {
                                if self.isGoodMemeFormat {
                                    HStack {
                                        Text(self.topText)
                                            .font(.title)
                                            .lineLimit(5)
                                            .multilineTextAlignment(.leading)
                                            .padding()
                                        Spacer()
                                    }
                                }
                                if self.memeImage != nil {
                                    self.memeImage?
                                        .resizable()
                                        .frame(width: metrics.size.width, height: metrics.size.width*self.imageAspectRatio, alignment: .center)
                                }
                            }
                            if !self.isGoodMemeFormat {
                                VStack {
                                    Text(self.topText)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .font(.custom("Impact", size: 50))
                                        .foregroundColor(Color(.white))
                                    Spacer()
                                    Text(self.bottomText)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .font(.custom("Impact", size: 50))
                                        .foregroundColor(Color(.white))
                                }
                            }
                        }
                        .frame(width: metrics.size.width, height: self.isGoodMemeFormat ? nil : metrics.size.width*self.imageAspectRatio, alignment: .center)
                        .background(RectGetter(rect: self.$memeRect))
                        .background(self.memeImage == nil ? Color(.clear) : Color(.systemBackground))
                        .environment(\.colorScheme, self.darkMeme ? .dark : .light)
                        .padding(.vertical, 16)
                        VStack(alignment: .center, spacing: 8) {
                            HStack {
                                Button(action: {
                                    self.showImagePicker = true
                                }) {
                                    Text("Pick Image")
                                        .padding(12)
                                        .background(Color(.systemPurple))
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                }
                                Button(action: {
                                    self.showMemeTypeAlert = true
                                    print("Height: \(metrics.size.width*self.imageAspectRatio)")
                                    print("Width: \(metrics.size.width)")
                                }) {
                                    Text("Set Meme Type")
                                        .padding(12)
                                        .background(Color(.systemPurple))
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                }
                                .actionSheet(isPresented: self.$showMemeTypeAlert) {
                                    ActionSheet(title: Text("Select Meme Type"), message: nil, buttons: [
                                        .default(Text("Old Style - Top & Bottom Text"), action: {
                                            self.isGoodMemeFormat = false
                                        }),
                                        .default(Text("New Style - Top Text Above Image"), action: {
                                            self.isGoodMemeFormat = true
                                        }),
                                        .cancel()
                                    ])
                                }
                            }
                            if self.isGoodMemeFormat {
                                Toggle(isOn: self.$darkMeme) {
                                    Text("Dark Background: ")
                                }
                                .padding(8)
                            }
                            Button(action: {
                                self.finishedMemeImage = UIApplication.shared.windows[0].rootViewController?.view.asImage(rect: self.memeRect)
                                self.shareMemePresented = true
                            }) {
                                Text("Share Meme")
                                    .padding(12)
                                    .background(Color(.systemPurple))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                        }
                        .padding()
                        Spacer()
                    }
                    .sheet(isPresented: self.$showImagePicker) {
                        ImagePicker(image: self.$memeImage, imageAspectRatio: self.$imageAspectRatio)
                        .accentColor(Color(.systemPurple))
                    }
                }
            .navigationBarTitle("Meme Maker")
            }
        }
            
        .sheet(isPresented: self.$shareMemePresented) {
            ShareSheet(activityItems: [self.finishedMemeImage])
            .accentColor(Color(.systemPurple))
        }
        .accentColor(Color(.systemPurple))
    }
}

struct RectGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { proxy in
            self.createView(proxy: proxy)
        }
    }

    func createView(proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = proxy.frame(in: .global)
        }

        return Rectangle().fill(Color.clear)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
