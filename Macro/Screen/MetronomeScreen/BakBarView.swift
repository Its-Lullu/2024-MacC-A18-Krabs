//
//  BakBarView.swift
//  Macro
//
//  Created by Yunki on 10/19/24.
//

import SwiftUI

struct BakBarView: View {
    var accent: Accent
    var isActive: Bool
    var bakNumber: Int?
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(accent > .medium
                          ? isActive ? .bakBarActive: .bakBarInactive
                          : .frame)
                Rectangle()
                    .fill(accent > .weak
                          ? isActive ? .bakBarActive : .bakBarInactive
                          : .frame)
                Rectangle()
                    .fill(accent > .none
                          ? isActive ? .bakBarActive : .bakBarInactive
                          : .frame)
            }
            
            if let bakNumber {
                Text("\(bakNumber)")
                    .font(.system(size: 32, weight: .semibold))
                    .padding(.top, 16)
                    .foregroundColor(
                        isActive
                        ? accent == .strong ? .bakBarNumberBlack : .bakBarNumberWhite
                        : accent == .strong ? .bakBarNumberBlack : .bakBarNumberGray
                    )
            }
        }
    }
}

#Preview {
    BakBarView(accent: .strong, isActive: true, bakNumber: 3)
}