//
//  SampleNode.swift
//  ARShowCase
//
//  Created by Heitor Feijó Kunrath on 09/02/23.
//

import Foundation
import SceneKit

struct BallFactory {
    var ballRadius: Float = 0.05
    var name: String = "ball"
    var normalImage: UIImage?
    
    init(image: UIImage) {
        self.normalImage = image
    }
    
    func createBall() -> SCNNode {
        let ball = SCNNode(geometry: SCNSphere(radius: CGFloat(ballRadius)))

        ball.name = name
        
        if let normalImage {
            ball.geometry?.firstMaterial?.normal.contents = normalImage
            ball.geometry?.firstMaterial?.diffuse.contents = normalImage
            ball.geometry?.firstMaterial?.emission.contents = normalImage
        } else {
            ball.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            ball.geometry?.firstMaterial?.emission.contents = UIColor.blue
        }

        let body = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: SCNSphere(radius: CGFloat(ballRadius)), options: nil))
        ball.physicsBody = body
        
        return ball
    }
}
