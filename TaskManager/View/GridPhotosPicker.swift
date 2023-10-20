//
//  MyPhotosPicker.swift
//  TaskManager
//
//  Created by 张鸿燊 on 10/10/2023.
//

import SwiftUI
import PhotosUI

struct GridPhotosPicker: View {
    @Binding var images: [FileMetaData]
    @State var column: Int = 3
    @State var spacing: CGFloat = 20
    @State var cornerRadius: CGFloat = 10
//    var matching: PHPickerFilter?
    
    
    @State private var selectedImageIndexSet: Set<Int> = Set<Int>()
    @State private var selectedImages: [FileMetaData] = []
    @State private var showFileExporter: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                let columnWidth: CGFloat = (geometry.size.width - spacing * CGFloat((column + 1))) / CGFloat(column)
                List(selection: $selectedImageIndexSet) {
                    var columns: [GridItem] {
                        var gridItems: [GridItem] = []
                        for _ in 0 ..< column {
                            gridItems.append(GridItem(.fixed(columnWidth)))
                        }
                        return gridItems
                    }
                    LazyVGrid(columns: columns, spacing: spacing){
                            ForEach(0 ..< images.count, id: \.self) {index in
                                if let image = Image(data: images[index].data) {
                                    image
                                    .resizable()
                                    .frame(width: columnWidth, height: columnWidth)
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                                    .tag(index)
                                }
                            }
                            .onDelete(perform: { indexSet in
                                indexSet.forEach { index in
                                    images.remove(at: index)
                                }
                            })
                            ImageSelectButton(images: $images)
                                .frame(width: columnWidth, height: columnWidth)
                                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            
                    }
                }
                .contextMenu(forSelectionType: Int.self){ indexSet in
                    if indexSet.isEmpty {
                        
                    } else {
                        Button(LocalizedStringKey("contextMenu.delete")) {
                            indexSet.forEach { index in
                                images.remove(at: index)
                            }
                        }
                        .keyboardShortcut(.delete, modifiers: [])
                        Button(LocalizedStringKey("contextMenu.save")) {
                            showFileExporter = true
                            indexSet.forEach { index in
                                selectedImages.append(images[index])
                            }
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
       
    }
}


extension GridPhotosPicker {
    
    struct ImageSelectButton: View {
        
        @Binding var images: [FileMetaData]
        
        @State private var selection: PhotosPickerItem? = nil
        @State private var showPermissionDeniedAlert = false
        @State private var isPickerPresented = false
        
        var body: some View {
            GeometryReader{ geometry in
                Button(action: {
                    #if os(macOS)
                    isPickerPresented = true
                    #elseif os(iOS)
                    let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
                    if status == .authorized || status == .limited {
                        // 如果已经有权限，打开照片选择器
                        isPickerPresented = true
                        print("authorized")
                    } else {
                        // 如果没有权限，请求权限
                        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                            print("request authorization")
                            DispatchQueue.main.async {
                                if status == .authorized || status == .limited {
                                    // 用户授予了权限，打开照片选择器
                                    isPickerPresented = true
                                    print("user authorized")
                                } else {
                                    // 用户拒绝了权限，显示弹框
                                    showPermissionDeniedAlert = true
                                    print("permission denied")
                                }
                            }
                        }
                    }
                    #endif
                }, label: {
                    Image(systemName: "plus")
                        .frame(width: geometry.size.width, height: geometry.size.height)
                })
                #if os(macOS)
                .fileImporter(isPresented: $isPickerPresented, allowedContentTypes: [.image],
                              allowsMultipleSelection: true, onCompletion: { result in
                    switch result {
                    case .success(let files):
                        files.forEach { file in
                            if file.startAccessingSecurityScopedResource() {
                                guard let data = try? Data(contentsOf: file) else {
                                    return
                                }
                                images.append(FileMetaData(data: data, fileName: file.lastPathComponent, type: .image))
                            }
                            
                        }
                    case .failure(let err):
                        print("error \(err)")
                    }
                })
                #elseif os(iOS)
                .photosPicker(isPresented: $isPickerPresented, selection: $selection, matching: .images)
                .alert(isPresented: $showPermissionDeniedAlert) {
                    Alert(
                        title: Text("无法访问相册"),
                        message: Text("请在设置中允许访问照片以选择照片。")
                    )
                }
                .task(id: selection) {
                    if let selection = selection {
                        selection.loadTransferable(type: Data.self, completionHandler: {result in
                            switch result {
                            case .success(let data):
                                if let data = data {
                                    images.append(FileMetaData(data: data, fileName: "", type: .image))
                                }
                            case .failure(let err):
                                print("load photo error, \(err)")
                            }
                        })
                    }
                }
                #endif
            }
                
        }
            
    }
}

#Preview {
    GridPhotosPicker(images: .constant([]))
}
