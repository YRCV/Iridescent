//
//  CDView.swift
//  Iridescent
//
//  Created by Yahil Corcino on 2/23/26.
//

import SwiftUI

struct CDView: View {
    @State private var startTime : Date = .now
    
    var body: some View {
        TimelineView(.animation) { context in
            let time = Float(context.date.timeIntervalSince(startTime))
            
            CDShape()
                .fill(Color.white, style: FillStyle(eoFill: true))
                .colorEffect(ShaderLibrary.cdIridescence(
                    .float2(300, 300),
                    .float(time)
                ))
                .frame(width: 300, height: 300)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CDView()
    }
}
