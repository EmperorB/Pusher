//
//  ContentView.swift
//  Shared
//
//  Created by Rajesh Budhiraja on 01/08/21.
//

import SwiftUI

struct ContentView: View {
    @State var payload: String = ""
    /*
     { "aps":
        {
            "alert":"hi some message",
            "badge":42
        }
     }
     */
    @State var apnsToken: String = ""
    @State var fileUrl: URL? = nil
    @State var topicId: String = ""
    @State var priority: String = "10"
    @State var password: String = ""
    let apiManager = ApiManager()
    
    var body: some View {
        ZStack {
            AppColors.PRIMARY_COLOR
            VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                
                HStack {
                    Image("pick-file").onTapGesture {
                        let panel = NSOpenPanel()
                        panel.allowedFileTypes = ["p12"]
                        panel.allowsMultipleSelection = false
                        panel.canChooseDirectories = false
                        panel.canChooseFiles = true
                        self.fileUrl = panel.runModal() == .OK ? panel.url : nil
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: nil) {
                        TextField("Topic ID", text: $topicId)
                            .font(.body)
                        TextField("Priority", text: $priority)
                            .font(.body)
                        SecureField("Certificate Password", text: $password)
                            .font(.body)
                    }
                    .padding(.trailing, 8)
                    .frame(width: 200, height: nil, alignment: .center)
                }
                
                
                Text((self.fileUrl == nil ? "No Cert Selected" : self.fileUrl?.lastPathComponent) ?? "")
                    .font(.body)
                    .padding(.leading, 8)
                    .padding(.bottom, 16)
                
                Text("Your APNs Token")
                    .font(.title)
                    .padding(.leading, 8)

                
                TextField("Debug Token", text: $apnsToken)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 4)
                    .cornerRadius(4)
                    .padding(.bottom, 16)
                    .font(.body)
                
                Text("Payload")
                    .font(.title)
                    .padding(.leading, 8)

                
                TextArea(text: $payload)
                    .frame(width: nil, height: 140, alignment: .leading)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 4)
                    .padding(.bottom, 16)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                HStack {
                    Spacer()
                    Button("Send Push") {
                        apiManager.delegate = self
                        apiManager.sendTestNotification()
                    }
                }
                .padding()
            })
        }
    }
}

extension ContentView: APIManagerDelegate {
    func getDeviceId() -> String {
        self.apnsToken
    }
    
    func getPayload() -> String {
        self.payload
    }
    
    func getTopic() -> String {
        self.topicId
    }
    
    func getPriority() -> String {
        self.priority
    }
    
    
    func getFilePath() -> URL? {
        self.fileUrl
    }
    
    func getPassword() -> String {
        self.password
    }
    
}
