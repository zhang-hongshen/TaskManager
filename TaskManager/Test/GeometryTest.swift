//
//  GeometryTest.swift
//  TaskManager
//
//  Created by 张鸿燊 on 10/10/2023.
//

import SwiftUI

struct GeometryTest: View {
    var body: some View {
        GeometryReader{ geometry in
            HStack(spacing: 0){
                Rectangle()
                    .fill(Color.red)
                    .frame(width: geometry.size.width * 0.666)
                Rectangle().fill(Color.blue)
                Text("width \(geometry.size.width)")
                Text("height \(geometry.size.height)")
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    GeometryTest()
}
