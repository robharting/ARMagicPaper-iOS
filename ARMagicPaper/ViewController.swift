//
//  ViewController.swift
//  ARMagicPaper
//
//  Created by Harting, R.P.G. (Rob) on 28/11/2024.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "NewsPaperImages", bundle: Bundle.main) {
            
            configuration.trackingImages = trackedImages
            
            configuration.maximumNumberOfTrackedImages = 1
            
            print("Images Found")
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    // called when image is detected - anchor is the image found
    func renderer(_ renderer: any SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
                                  
            // what image did we detect
            print(imageAnchor.referenceImage.name!)
            
            let videoNode = SKVideoNode(fileNamed: "harrypotter.mp4")
            videoNode.play()
            
            // sprite kit to video kit
            let videoScene = SKScene(size: CGSize(width: 480, height: 360))
            
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.width / 2)
            
            // rotate it
            videoNode.yScale = -1.0
            
            videoScene.addChild(videoNode)
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = videoScene
            
            let planeNode = SCNNode(geometry: plane)
            
            // make the image flat - half a pi is 90 degrees
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
            
        }
        
        return node
    }
  

}
