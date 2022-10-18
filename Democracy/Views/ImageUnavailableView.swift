//
//  ImageUnavailableView.swift
//  Democracy
//
//  Created by Jevon Mao on 10/18/22.
//

import SwiftUI

struct ImageUnavailableView: View {
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.square.fill")
                .imageScale(.large)
                .foregroundColor(.yellow)
            Text("Image Unavailable")
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.top, 3)
                .opacity(0.6)

        }
        .frame(width: 184, height: 283)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct ImageUnavailableView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUnavailableView()
    }
}
