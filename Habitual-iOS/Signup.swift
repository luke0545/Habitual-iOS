//
//  Login.swift
//  Habitual-iOS
//
//  Created by Luke on 4/03/24.
//

import Foundation
import SwiftUI

struct SignupView: View 
{

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    // Password error handling
    @State private var showPasswordError = false
    @State private var showConfirmError = false

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
                Text("Create an account")
                  .font(.headline)
              }
              .padding(.top, 50)

            // Username and password fields
            VStack(spacing: 10) {
                TextField("Create a username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)

                SecureField("Choose a Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)

                // Error message for password validity (hidden initially)
                if !isValidPassword($password.wrappedValue) && showPasswordError {
                    Text("Password must contain at least one digit.")
                        .font(.caption)
                        .foregroundColor(.red)
                }

                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)

                // Error message for password match (hidden initially)
                if !$password.wrappedValue.isEqual($confirmPassword.wrappedValue) && showConfirmError {
                    Text("Passwords do not match")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .padding(30)

            // Sign up button
            HStack {
                Spacer()
                Button(action: {
                    showPasswordError = !isValidPassword($password.wrappedValue)
                    showConfirmError = !$password.wrappedValue.isEqual($confirmPassword.wrappedValue)
                    // Handle Sign on button click
                    if (!showPasswordError && !showConfirmError)
                    {
                        print("Signing in...")
                        print("Username: ", $username.wrappedValue)
                        print("Password: ", $password.wrappedValue)
                    }
                    else
                    {
                        print("Not signed in. Errors in login info...")
                        print("Username: ", $username.wrappedValue)
                        print("Password: ", $password.wrappedValue)
                    }
                }) {
                    Text("Sign Up")
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
                          Text("Already have an account?")
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
                                  Text("Sign In")
                                      .font(.footnote)
                                      .foregroundColor(.blue)
                              }
                              .padding(.top, 20)
                              .padding(.leading, -160)
                      }
                      Spacer()
                  }
                  .padding(.leading, 20)
                  
              }
              Spacer()
          
        }
        .background(Color.white)
    }
    func isValidPassword(_ password: String) -> Bool
    {
          // Regular expression to check for at least one digit
          let regex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[0-9])")
          
          // Check if password has at least one digit and both passwords match
        return regex.evaluate(with: password) && password == $password.wrappedValue
    }
}

#Preview {
    SignupView()
}
