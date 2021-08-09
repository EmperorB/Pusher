//
//  MultilineTextField.swift
//  Pusher
//
//  Created by Rajesh Budhiraja on 01/08/21.
//

import SwiftUI

//MARK: MacOS
struct TextArea: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSScrollView {
        context.coordinator.createTextViewStack()
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let textArea = nsView.documentView as? NSTextView, textArea.string != self.text {
            textArea.string = self.text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var text: Binding<String>

        init(text: Binding<String>) {
            self.text = text
        }

        func textView(_ textView: NSTextView, shouldChangeTextIn range: NSRange, replacementString text: String?) -> Bool {
            defer {
                self.text.wrappedValue = (textView.string as NSString).replacingCharacters(in: range, with: text!)
            }
            return true
        }

        fileprivate lazy var textStorage = NSTextStorage()
        fileprivate lazy var layoutManager = NSLayoutManager()
        fileprivate lazy var textContainer = NSTextContainer()
        fileprivate lazy var textView: NSTextView = NSTextView(frame: CGRect(), textContainer: textContainer)
        fileprivate lazy var scrollview = NSScrollView()

        func createTextViewStack() -> NSScrollView {
            let contentSize = scrollview.contentSize

            textContainer.containerSize = CGSize(width: contentSize.width, height: CGFloat.greatestFiniteMagnitude)
            textContainer.widthTracksTextView = true

            textView.minSize = CGSize(width: 0, height: 0)
            textView.maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            textView.isVerticallyResizable = true
            textView.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
            textView.autoresizingMask = [.width]
            textView.textColor = .white
            textView.isRichText = false
            textView.isAutomaticQuoteSubstitutionEnabled = false
            
            textView.delegate = self

            scrollview.borderType = .bezelBorder
            scrollview.hasVerticalScroller = true
            scrollview.documentView = textView

            textStorage.addLayoutManager(layoutManager)
            layoutManager.addTextContainer(textContainer)

            return scrollview
        }
    }
}
