//
//  ResizeImageVIew.swift
//  PixelMorph
//
//  Created by Mohamed Abdullahi on 13/08/2024.
//
import SwiftUI
import UIKit

struct ResizeImageView: View {
    @Binding var image: UIImage?
    @Binding var videoURL: URL?
    
    @State private var selectedSize: HashableCGSize = HashableCGSize(width: 1024, height: 512)
    @State private var showCustomSize: Bool = false
    @State private var customWidth: CGFloat = 100
    @State private var customHeight: CGFloat = 100
    
    let presetSizes = [
        HashableCGSize(width: 1024, height: 512),
        HashableCGSize(width: 800, height: 600),
        HashableCGSize(width: 640, height: 480),
        HashableCGSize(width: 320, height: 240)
    ]
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Resize Your Image")
                    .font(.custom("NEONLEDLightRegular", size: 24))
                    .foregroundColor(.white)
                    .padding()
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 300)
                        .border(Color.white, width: 1)
                        .padding()
                } else {
                    Text("No image selected")
                        .foregroundColor(.gray)
                }
                
                Picker("Select Size", selection: $selectedSize) {
                    ForEach(presetSizes, id: \.self) { size in
                        Text("\(Int(size.width)) x \(Int(size.height))")
                            .foregroundColor(.white)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button(action: {
                    withAnimation {
                        showCustomSize.toggle()
                    }
                }) {
                    Text(showCustomSize ? "Hide Custom Size" : "Enter Custom Size")
                        .padding()
                        .font(.custom("Orbitron-Regular", size: 12))
                        .background(Color.gray)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                .padding()
                
                if showCustomSize {
                    HStack {
                        Text("Width:")
                            .foregroundColor(.white)
                            .font(.custom("Orbitron-Regular", size: 10))
                        
                        TextField("Width", value: $customWidth, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 100)
                        
                        Text("Height:")
                            .foregroundColor(.white)
                            .font(.custom("Orbitron-Regular", size: 10))
                        
                        TextField("Height", value: $customHeight, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 100)
                    }
                    .padding()
                }
                
                Button(action: {
                    resizeAndSaveImage()
                }) {
                    Text("Resize and Save")
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(8)
                        .font(.custom("Orbitron-Regular", size: 12))
                        .foregroundColor(.white)
                }
                .padding()
            }
        }
    }
    
    private func resizeAndSaveImage() {
        guard let image = image else { return }
        
        let size = showCustomSize ? CGSize(width: customWidth, height: customHeight) : selectedSize.size
        let renderer = UIGraphicsImageRenderer(size: size)
        let newImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
    }
}

struct HashableCGSize: Hashable {
    var size: CGSize

    init(width: CGFloat, height: CGFloat) {
        self.size = CGSize(width: width, height: height)
    }

    var width: CGFloat {
        size.width
    }

    var height: CGFloat {
        size.height
    }

    // Conformance to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(size.width)
        hasher.combine(size.height)
    }

    static func ==(lhs: HashableCGSize, rhs: HashableCGSize) -> Bool {
        return lhs.size == rhs.size
    }
}



