//
//  ViewController.swift
//  Planets
//
//  Created by Karlo Pagtakhan on 09/26/2017.
//  Copyright © 2017 kidap. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    enum StarsPlanets: String {
        case earth
        case sun
        
        var node: SCNNode {
            
            let node = SCNNode()
            node.geometry = self.geometry
            node.geometry?.firstMaterial?.diffuse.contents = self.diffuse
            node.geometry?.firstMaterial?.specular.contents = self.specular
            node.geometry?.firstMaterial?.emission.contents = self.emission
            node.geometry?.firstMaterial?.normal.contents = self.normal
            
            let parentNode = SCNNode()
            parentNode.addChildNode(node)
            
            if let rotationDuration = self.rotationDuration {
                let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degToRad()), z: 0, duration: rotationDuration)
                let repeatForever = SCNAction.repeatForever(action)
                node.runAction(repeatForever)
            }
            
            if let parentRotationDuration = self.parentRotationDuration {
                let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degToRad()), z: 0, duration: parentRotationDuration)
                let foreverAction = SCNAction.repeatForever(action)
                node.parent?.runAction(foreverAction)
            }
            
            if let moons = self.moons, !moons.isEmpty {
                moons.forEach { moon in
                    node.addChildNode(moon)
                }
            }
            
            return node
        }
        
        var geometry: SCNGeometry {
            switch self {
            case .earth: return SCNSphere(radius: 0.2)
            case .sun: return SCNSphere(radius: 0.4)
            }
        }
        
        var diffuse: Any? {
            switch self {
            case .earth: return #imageLiteral(resourceName: "earth")
            case .sun: return #imageLiteral(resourceName: "sun")
            }
        }
        var specular: Any? {
            switch self {
            case .earth: return #imageLiteral(resourceName: "earth_specular")
            default: return nil
            }
        }
        
        var emission: Any? {
            switch self {
            case .earth: return #imageLiteral(resourceName: "earth_clouds")
            default: return nil
            }
        }
        
        var normal: Any? {
            switch self {
            case .earth: return #imageLiteral(resourceName: "earth_normal")
            default: return nil
            }
        }
        
        var rotationDuration: Double? {
            switch self {
            case .earth: return 8
            case .sun: return 8
            }
        }
        
        var parentRotationDuration: Double? {
            switch self {
            case .earth: return 8
            case .sun: return nil
            }
        }
        
        var moons: [SCNNode]? {
            switch self {
            case .earth:
                let node = SCNNode()
                node.geometry = SCNSphere(radius: 0.05)
                node.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "moon")
                node.position = SCNVector3(0,0,-0.5)
                let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degToRad()), z: 0, duration: 2)
                let repeatForever = SCNAction.repeatForever(action)
                node.runAction(repeatForever)
                return [node]
            case .sun: return nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let earthNode = StarsPlanets.earth.node
        earthNode.position = SCNVector3(0,0,-3)
        
        let sunNode = StarsPlanets.sun.node
        sunNode.position = SCNVector3(0,0,-1)
        
        sceneView.scene.rootNode.addChildNode(sunNode)
        sceneView.scene.rootNode.addChildNode(earthNode.parent!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

private extension ViewController {
    func setupSceneView() {
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.run(configuration, options: [])
        sceneView.autoenablesDefaultLighting = true
    }
}

extension Int {
    
    func degToRad() -> Double {
        return Double(self) * .pi / 180
        
    }
    
}
