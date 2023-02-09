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
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        //named: "art.scnassets/ship.scn"
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
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

    
    // with the help pf Brian Advent's You Tube Channel 
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
}

// this extension was developed with thanks to https://github.com/arirawr/ARKit-FloorIsLava
extension ViewController: ARSCNViewDelegate {
    
    func createPlaneNode(anchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
    
        plane.firstMaterial?.diffuse.contents = UIColor.cyan
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)

        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)

        return planeNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let planeNode = createPlaneNode(anchor: planeAnchor)
        node.addChildNode(planeNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
        let planeNode = createPlaneNode(anchor: planeAnchor)
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
