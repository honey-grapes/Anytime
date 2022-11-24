//
//  ScanButton.swift
//  Anytime
//
//  Created by Josephine Chan on 10/21/22.
//

import SwiftUI
import Vision
import VisionKit

@available(iOS 16.0, *)
//Wrapper for SwiftUI to use UIViewController in UIKit
//DataScannerViewController which scans camera live video for data inherits UIViewController
struct ScannerViewController: UIViewControllerRepresentable {
    @Binding var openScanner: Bool
    @Binding var scanResult: String
    
    @available(iOS 16.0, *)
    //Creates the initial view controller
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let dataScanner = DataScannerViewController(
            recognizedDataTypes: [.text(languages: ["en-US", "zh-Hant", "zh-Hans"])],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        dataScanner.delegate = context.coordinator
        
        return dataScanner
    }
    
    //Update the view controller after state change
    func updateUIViewController(_ dataScanner: DataScannerViewController, context: Context) {
        if openScanner {
            try? dataScanner.startScanning()
        }
        else {
            dataScanner.stopScanning()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    //Swift UI coordinators are delegates that listen to events and handles user interactions
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        //Boilerplate for initializing
        var parent: ScannerViewController
        init (_ parent: ScannerViewController){
            self.parent = parent
        }
        
        //When a new recognizable object is detected
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                parent.scanResult = text.transcript
            default:
                break
            }
        }
    }
}
