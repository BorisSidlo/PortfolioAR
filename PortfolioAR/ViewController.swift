//
//  ViewController.swift
//  PortfolioAR
//
//  Created by Boris Sidlo on 01/02/2021.
//

import UIKit
import RealityKit
import ARKit
//import AR kit
//delte stfuuf



class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        // overvider deafult ar kit
        super.viewDidAppear(animated)
        
        arView.session.isEqual(self)
        setupARview()
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }
    
    func setupARview(){
        
        // MARK
        
    arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        
        // better textures
        configuration.environmentTexturing = .automatic
        
        // run confugration
        arView.session.run(configuration)
    }


    @objc
    func handleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: arView)
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
            
        if let firstResults = results.first{
            // order to place wee need anchor
            // multiUser to sycnhornize acnhor need
            let anchor = ARAnchor(name: "ContemporaryFan", transform: firstResults.worldTransform)
            arView.session.add(anchor: anchor)
        }else{
            print("FIND PLANE ")
        }
        
        
        }
    
    
    func placeObject(named entityName:String,for anchor: ARAnchor){
        // we create model entity
        let entity = try! ModelEntity.loadModel(named: entityName)
        
        //drag and rotate
        arView.installGestures([.rotation, .translation], for: entity)
        let anchorEntity = AnchorEntity(anchor:anchor)
        anchorEntity.addChild(entity)
        arView.scene.addAnchor(anchorEntity)
    }
    
}
   extension ViewController: ARSessionDelegate{
        func session(_session:ARSession, didAdd anchors: [ARAnchor]){
            for anchor in anchors{
                if let anchorName = anchor.name, anchorName == "ContemporaryFan"{
                    // place object with name for specification
                    placeObject(named: anchorName, for: anchor)
                }
            }
       }
    }






    // tap gesture recognizitaon
// layser point to virtual laser if it is intesction

        
// gesture recongize


    
    

    
    
  

