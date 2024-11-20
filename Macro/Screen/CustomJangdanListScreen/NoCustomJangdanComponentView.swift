//
//  NoCustomJangdanComponentView.swift
//  Macro
//
//  Created by jhon on 11/20/24.
//

import SwiftUI

struct NoCustomJangdanComponentView: View {
    var body: some View {
        ZStack {
            HStack() {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("아직 저장한 장단이 없어요")
                        .font(.Subheadline_R) // SwiftUI 문법에서 소문자로 시작
                        .foregroundColor(.textTertiary)
                    
                    Text("장단 만들러 가기")
                        .font(.Title3_R)
                        .foregroundColor(.textSecondary)
                    
                }
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .fontWeight(.semibold)
                        .frame(width: 20, height: 22)
                        .foregroundColor(.textTertiary)
                
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.backgroundCard)
            .cornerRadius(16)
        }
    }
}

struct NoCustomJangdanComponentView_Previews: PreviewProvider {
    static var previews: some View {
        NoCustomJangdanComponentView()
            .frame(width: 361, height: 97)
    }
}