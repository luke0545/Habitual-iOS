//
//  Login.swift
//  Habitual-iOS
//
//  Created by Luke on 4/03/24.
//

import Foundation
import SwiftUI

struct LoginView: View 
{

    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View 
    {
        VStack
        {
            // Title section
              VStack(spacing: 10)
            {
                Text(/*@START_MENU*/"Habitual"/*@END_MENU*/)
                  .font(.title)
                  .fontWeight(.bold)
                Text("Sign Into your account")
                  .font(.headline)
            }
            .padding(.top, 50)

            // Username and password fields
            VStack(spacing: 10) 
            {
                TextField("Username", text: $username)
                  .padding()
                  .background(Color.gray.opacity(0.2))
                  .cornerRadius(5)
                SecureField("Password", text: $password)
                  .padding()
                  .background(Color.gray.opacity(0.2))
                  .cornerRadius(5)
            }
            .padding(30)

            // Sign in button
            HStack 
            {
                Spacer()
                Button(action:
                {
                    print("Username: ", $username)
                    print("Password: ", $password)
                })
                {
                  Text("Sign In")
                    .foregroundColor(.white)
                    .padding()
                }
                .frame(width: 200)
                .background(Color.gray)
                .cornerRadius(5)
                Spacer()
            }
            .padding(.top, 5)

            // Sign up link
            VStack(alignment: .leading) 
            {
                  HStack
                  {
                          VStack
                          {
                              Text("Don't have an account?")
                              .font(.footnote)
                          }
                          .padding(.top, 20)
                          .padding(.bottom, 50)
                            
                          VStack
                          {
                              NavigationLink
                              {
                                  LoginView()
                              } label:
                                  {
                                      Text("Sign Up")
                                          .font(.footnote)
                                          .foregroundColor(.blue)
                                  }
                                  .padding(.top, 20)
                                  .padding(.leading, -150)
                          }
                          
                          Spacer()
                  }
                  .padding(.leading, 20)
              
            }
          Spacer()
        }
        .background(Color.white)
    }
//    func isValidPassword(_ password: String) -> Bool 
//    {
//          // Regular expression to check for at least one digit
//          let regex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[0-9])")
//          
//          // Check if password has at least one digit and both passwords match
//          return regex.evaluate(with: password) && password == $password // Reference current password binding
//    }
}

#Preview {
    LoginView()
}
