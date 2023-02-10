//
//  ViewController.swift
//  ARShowCase
//
//  Created by Heitor Feijó Kunrath on 09/02/23.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        let scene = SCNScene()
        
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    
    //  this func was developed with the help of Brian Advent's You Tube Channel 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: sceneView) else { return }
        
        let query = sceneView.raycastQuery(from: location, allowing: .existingPlaneInfinite, alignment: .any)
     
        let queryResult = sceneView.session.raycast(query!)
        
        if let hitResult = queryResult.first {
            let transform = hitResult.worldTransform
            
            let ballFactory = BallFactory(image: UIImage(named: "mars")!)
            let ballNode = ballFactory.createBall()
            let position = SCNVector3(x: transform.columns.3.x, y: transform.columns.3.y + ballFactory.ballRadius, z: transform.columns.3.z )

            ballNode.position = position
            
            sceneView.scene.rootNode.addChildNode(ballNode)
        }
        
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    

    @IBAction func removeBallsTouchUpInside(_ sender: Any) {
            removeBalls()
    }
    
    private func removeBalls() {
        for node in sceneView.scene.rootNode.childNodes {
            if node.name == "ball" {
                node.removeFromParentNode()
            }
        }
    }
}

// this extension was developed with the help of this repo https://github.com/arirawr/ARKit-FloorIsLava
extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let planeNode = PlaneFactory().createPlaneNode(width, height)
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        node.addChildNode(planeNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let planeNode = PlaneFactory().createPlaneNode(width, height)
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        node.addChildNode(planeNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }

        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
}
