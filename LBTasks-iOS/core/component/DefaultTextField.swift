//
//  DefaultTextField.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 21/10/23.
//

import Foundation
import SwiftUI

struct DefaultTextField: View {
    let placeholder: String
    let value: Binding<String>
    let imageName: String
    @State private var hidePassword = false
    var isPassword = false
    @State private var isSecured: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            
            let textField = CustomTextField(
                text: value,
                placeholder: placeholder,
                imageName: imageName
            )
            
            if isPassword {
                ZStack(alignment: .trailing) {
                    if isSecured {
                        CustomSecureTextField(
                            text: value,
                            placeholder: placeholder,
                            imageName: imageName
                        )
                    } else {
                        textField
                    }
                    
                    Button(action: {
                        isSecured.toggle()
                    }) {
                        Image(
                            systemName: self.isSecured
                            ? "eye.slash"
                            : "eye"
                        ).accentColor(.gray)
                    }
                }
            } else {
                textField
            }
            
            
        }
    }
}

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let imageName: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .imageScale(.large)

            TextField(placeholder, text: $text)
                .font(.system(size: 18))
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
}

struct CustomSecureTextField: View {
    @Binding var text: String
    let placeholder: String
    let imageName: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .imageScale(.large)

            SecureField(placeholder, text: $text)
                .font(.system(size: 18))
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
}

struct DefaultTextField_Previews: PreviewProvider {
    static var previews: some View {
        @State var editingText: String = ""
        
        return DefaultTextField(
            placeholder: "This is a hint",
            value: $editingText,
            imageName: "rainbow",
            isPassword: true
        )
    }
}
