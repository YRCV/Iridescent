//
//  CDShape.swift
//  Iridescent
//
//  Created by Yahil Corcino on 2/23/26.
//

import SwiftUI

struct CDShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center  = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.10
        
        path.addEllipse(in: CGRect(
            x: center.x - outerRadius,
            y: center.y - outerRadius,
            width: outerRadius * 2,
            height: outerRadius * 2
        ))
        path.addEllipse(in: CGRect(
            x: center.x - innerRadius,
            y: center.y - innerRadius,
            width: innerRadius * 2,
            height: innerRadius * 2
        ))
        
        return path
    }
}
