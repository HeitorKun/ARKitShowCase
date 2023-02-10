//
//  PlaneFactory.swift
//  ARShowCase
//
//  Created by Heitor Feijó Kunrath on 10/02/23.
//

import Foundation
import ARKit

struct PlaneFactory {
    
    func createPlaneNode(_ width: CGFloat, _ height: CGFloat) -> SCNNode {
        let plane = SCNPlane(width: width , height: height)
        plane.firstMaterial?.diffuse.contents = UIImage(named: "universe")
        let planeNode = SCNNode(geometry: plane)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)

        return planeNode
    }
}
