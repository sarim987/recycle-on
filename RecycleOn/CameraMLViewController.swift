//
//  CameraMLViewController.swift
//  RecycleOn
//
//  Created by Aristotel Fani on 12/7/18.
//  Copyright © 2018 SAKT. All rights reserved.
//

import UIKit
import Vision
import AVKit

class CameraMLViewController: UIViewController {

    var captureSession: AVCaptureSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)

    }

}

extension CameraMLViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: ImageClassifier().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishReq, err) in
            if err != nil { print(err!) }
            guard let results = finishReq.results as? [VNClassificationObservation] else { return }
            guard let firstObs = results.first else { return }
            if firstObs.identifier == "Recycling" {
                self.captureSession.stopRunning()
                let points = Int.random(in: 50 ..< 250)
                self.createAlertController(title: "Hooray you recycled!!!", message: "You earned \(points) points!", image: "checkmark", addPoints: points)
//                DispatchQueue.main.async {
//                    self.dismiss(animated: true)
//                }
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
