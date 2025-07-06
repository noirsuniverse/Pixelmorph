# PixelMorph 🔄📸
**Convert, resize, and optimize images in multiple formats**  
*A SwiftUI-powered iOS app for seamless image format conversion*

![Demo GIF](Example1.gif) *(Upload a screen recording to your repo and link it here)*

## ✨ Features
- Convert images to **PNG, JPEG, HEIC, TIFF, BMP**
- Preserve quality with adjustable compression
- Save directly to Photos library
- Clean, dark-mode-friendly UI
- Custom font styling with `NEONLEDLight` and `Orbitron`

## 🛠 Tech Stack
![Swift](https://img.shields.io/badge/Swift-5.9-white?logo=swift)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-black?logo=swift)
![iOS](https://img.shields.io/badge/iOS-16+-lightgrey?logo=apple)

```swift
import SwiftUI
import PhotosUI
import AVFoundation

struct ContentView: View {
    @State private var image: UIImage? = nil
    @State private var videoURL: URL? = nil
    @State private var showImagePicker: Bool = false
    @State private var selectedFormat: String = "PNG"
    
    // Updated formats to include TIFF, BMP, WEBP, JPEG2000, PDF
    let formats = ["PNG", "JPEG", "HEIC", "TIFF", "BMP"]

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Image("Image")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding(.top, 20)
                    
                    Text("PixelMorph")
                        .font(.custom("NEONLEDLightRegular", size: 30))
                        .padding()
                        .foregroundColor(.gray)
                    
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300, maxHeight: 300)
                            .border(Color.white, width: 1)
                            .padding(.horizontal)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        Text("Select an image")
                            .font(.custom("NEONLEDLightRegular", size: 24))
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("Choose Image")
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.white)
                            .font(.custom("Orbitron-Regular", size: 18))
                            .cornerRadius(10)
                    }
                    
                    Picker("Select Format", selection: $selectedFormat) {
                        ForEach(formats, id: \.self) {
                            Text($0)
                                .foregroundColor(.white)
                                .font(.custom("NEONLEDLightRegular", size: 18))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    
                    Button(action: {
                        convertAndSaveImage()
                    }) {
                        Text("Convert and Save")
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.white)
                            .font(.custom("Orbitron-Regular", size: 18))
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: ResizeImageView(image: $image, videoURL: $videoURL)) {
                        Text("Resize Image")
                            .padding()
                            .font(.custom("Orbitron-Regular", size: 12))
                            .background(Color.gray)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(mediaType: "image", image: $image, videoURL: $videoURL)
            }
            .navigationBarHidden(true)
        }
    }
    
    func convertAndSaveImage() {
        guard let image = image else { return }
        
        let imageData: Data?
        let fileExtension: String
        
        switch selectedFormat {
        case "JPEG":
            imageData = image.jpegData(compressionQuality: 1.0)
            fileExtension = "jpg"
        case "HEIC":
            imageData = image.heicData() // Custom function to convert to HEIC
            fileExtension = "heic"
        case "TIFF":
            imageData = image.tiffData() // Custom function to convert to TIFF
            fileExtension = "tiff"
        case "BMP":
            imageData = image.bmpData() // Custom function to convert to BMP
            fileExtension = "bmp"
        default: // PNG
            imageData = image.pngData()
            fileExtension = "png"
        }
        
        if let data = imageData {
            let url = getDocumentsDirectory().appendingPathComponent("converted_image.\(fileExtension)")
            try? data.write(to: url)
            saveToPhotoLibrary(image: UIImage(data: data)!)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func saveToPhotoLibrary(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

