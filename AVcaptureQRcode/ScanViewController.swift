//
//  ScanViewController.swift
//  AVcaptureQRcode
//
//  Created by sim on 2018/2/8.
//  Copyright © 2018年 wanglupeng. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{

    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var centView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCaptureDevice()
        self .customUI()
    }
    func customUI() {
        centView.layer.borderColor = UIColor.red.cgColor
        centView.layer.borderWidth = 1
        self.view.bringSubview(toFront: centView)
    }
    func addCaptureDevice()  {
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            //初始化媒体捕捉的输入流
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            //初始化AVcaptureSession
            captureSession = AVCaptureSession()
            //设置输入到Session
            captureSession?.addInput(input)
        }  catch  {
            // 捕获到移除就退出
            print(error)
            return
        }
        
        let Output = AVCaptureMetadataOutput()
        captureSession?.addOutput(Output)
        
        //设置代理 扫描的目标设置为二维码
        Output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        Output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
        
    }

    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            return
        }
        
        // 取出第一个对象
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            if metadataObj.stringValue != nil {
                captureSession?.stopRunning()
                print(metadataObj.stringValue!)
            }
        }
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
