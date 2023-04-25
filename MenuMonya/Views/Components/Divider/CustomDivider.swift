//
//  CustomDivider.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/22.
//

import SwiftUI

struct CustomDivider: View {
    var color: Color
    
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(color)
    }
}

struct CustomDivider_Previews: PreviewProvider {
    static var previews: some View {
        CustomDivider(color: Color("grey_200"))
    }
}
