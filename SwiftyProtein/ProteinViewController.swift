//
//  ProteinViewController.swift
//  SwiftyProtein
//
//  Created by Nikolas Ponomarov on 09.07.2018.
//  Copyright © 2018 Mykola Ponomarov. All rights reserved.
//

import UIKit
import SceneKit
import Photos

extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

class ProteinViewController: UIViewController {

    @IBOutlet weak var hideLinesBtn: UIButton!
    @IBOutlet weak var hideBallsBtn: UIButton!
    
    @IBOutlet weak var colorTF: UITextField!
    @IBOutlet weak var atomName: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    
    var proteinData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.addTarget(self, action: #selector(showName))
        sceneView.addGestureRecognizer(tapRecognizer)
        
        createScene()
        sceneView.cameraControlConfiguration.rotationSensitivity = 0.5
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let rightBtn = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonPressed))
        self.navigationItem.rightBarButtonItem = rightBtn
        self.colorTF.isUserInteractionEnabled = false;
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: Notification.Name("appDidEnterBackground") , object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Action methods
    
    @IBAction func hideLinesBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func hideBallsBtnPressed(_ sender: Any) {
        
    }
    
    @objc func appDidEnterBackground(notification: Notification) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @objc func shareButtonPressed() {
        
        DispatchQueue.main.async {
            
//            // create graphics context with screen size
//            let screenRect = UIScreen.main.bounds
//            UIGraphicsBeginImageContext(screenRect.size);
//            let ctx = UIGraphicsGetCurrentContext();
//            ctx?.fill(screenRect);
//
//            // grab reference to our window
//            let window = UIApplication.shared.keyWindow
//
//            // transfer content into our context
//            window?.layer.render(in: ctx!)
//            let imageToShare = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
            
            let imageToShare = self.view.toImage()
            
            let activityItems : NSMutableArray = []
            activityItems.add(imageToShare)
            
            let activityVC = UIActivityViewController(activityItems:activityItems as [AnyObject] , applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @objc func showName(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        
        let hitResults = sceneView.hitTest(location, options: nil)
        if hitResults.count > 0
        {
            let atom = hitResults[0]
            let atomNode = atom.node
            let number = atomNode.name
            if (number == nil)
            {
                return
            }
            for i in proteinData
            {
                if i.hasPrefix("ATOM")
                {
                    
                    let separatedString = i.split(separator: " ", maxSplits: 10000, omittingEmptySubsequences: true)
                    if (Int(number!) == Int(separatedString[1])!)
                    {
                        atomName.text = "Selected atom: " + String(separatedString[11])
                        self.colorTF.backgroundColor = getColor(name: String(separatedString[11]))
                        self.colorTF.isHidden = false
                    }
                    
                }
            }
            
        }
    }
    
    // MARK: - Get method
    
    func getColor(name: String) -> UIColor{
        switch name {
        case "H":
            return UIColor.white
        case "C":
            return UIColor.black
        case "N":
            return UIColor.init(red: 0.0, green: 0.0, blue: 128.0, alpha: 1)
        case "O":
            return UIColor.red
        case "F", "CL":
            return UIColor.green
        case "BR":
            return UIColor.init(red: 139.0, green: 0.0, blue: 0.0, alpha: 1)
        case "I":
            return UIColor.purple
        case "HE", "NE", "AR", "XE", "KR":
            return UIColor.cyan
        case "P":
            return UIColor.orange
        case "S":
            return UIColor.yellow
        case "B":
            return UIColor.init(red: 255.0, green: 229.0, blue: 180.0, alpha: 1)
        case "LI", "NA", "K", "RB", "CS", "FR":
            return UIColor.init(red: 238.0, green: 130.0, blue: 238.0, alpha: 1)
        case "BE", "MG", "CA", "SR", "BA", "RA":
            return UIColor.init(red: 0.0, green: 100.0, blue: 0.0, alpha: 1)
        case "TI":
            return UIColor.gray
        case "FE":
            return UIColor.init(red: 255.0, green: 140.0, blue: 0.0, alpha: 1)
        default:
            return UIColor.init(red: 255.0, green: 192.0, blue: 203.0, alpha: 1)
        }
    }
    
    
    // MARK: Init methods
    
    func createAtom(name: String, x: Double, y: Double, z: Double, number: Int) -> SCNNode
    {
        let atom = SCNSphere(radius: 0.4)
        atom.firstMaterial!.diffuse.contents = getColor(name: name)
        atom.firstMaterial!.specular.contents = UIColor.white
        let atomNode = SCNNode(geometry: atom)
        atomNode.position = SCNVector3(x, y, z)
        atomNode.name = String(number)
        
        return atomNode
    }
    
    func makeConnection(first: SCNNode, second: SCNNode, scene: SCNScene) -> SCNNode
    {
        var color = UIColor()
        for i in proteinData
        {
            if i.hasPrefix("ATOM")
            {
                
                let separatedString = i.split(separator: " ", maxSplits: 10000, omittingEmptySubsequences: true)
                if (Int(first.name!) == Int(separatedString[1])!)
                {
                    color = getColor(name:String(separatedString[11]))
                }
                
            }
        }
        let connection = CylinderLine(parent: scene.rootNode, v1: first.position, v2: second.position, radius: 0.1, radSegmentCount: 16, color: color)
        connection.name = "-1"
        return connection
    }
    
    func createScene()
    {
        let scene = SCNScene()

        for i in proteinData
        {
            if i.hasPrefix("ATOM")
            {
                
                let separatedString = i.split(separator: " ", maxSplits: 10000, omittingEmptySubsequences: true)
                let atom = createAtom(name: String(separatedString[11]),
                                      x: Double(separatedString[6])!,
                                      y: Double(separatedString[7])!,
                                      z: Double(separatedString[8])!,
                                      number: Int(separatedString[1])!)
                scene.rootNode.addChildNode(atom)
            }
            
        }
        
        let temp = scene.rootNode.childNode(withName: String(Int(scene.rootNode.childNodes.count / 2)), recursively: true)
        let tempPosition = temp?.position
        for node in scene.rootNode.childNodes
        {
            node.position.x -= (tempPosition?.x)!
            node.position.y -= (tempPosition?.y)!
            node.position.z -= (tempPosition?.z)!
        }
        for i in proteinData
        {
            if i.hasPrefix("CONECT")
            {
                let separatedString = i.split(separator: " ", maxSplits: 10000, omittingEmptySubsequences: true)
                let first = scene.rootNode.childNode(withName: String(separatedString[1]),
                                                     recursively: false)
                var counter = 2
                while counter < separatedString.count
                {
                    
                    let second = scene.rootNode.childNode(withName: String(separatedString[counter]),
                                                          recursively: false)
                    if (second != nil && first != nil)
                    {
                        let connection = makeConnection(first: first!, second: second!, scene: scene)
                        scene.rootNode.addChildNode(connection)
                    }
                    counter += 1
                }
            }
            else if i.hasPrefix("END")
            {
                break
            }
        }
        
        sceneView.scene = scene
        
        print("Scene created")
    }
}

// MARK: - CylinderLine class

class   CylinderLine: SCNNode
{
    init( parent: SCNNode,
          v1: SCNVector3,
          v2: SCNVector3,
          radius: CGFloat,
          radSegmentCount: Int,
          color: UIColor )
    {
        super.init()
        
        let  height = v1.distance(receiver: v2)
        position = v1
        let nodeV2 = SCNNode()
        nodeV2.position = v2
        parent.addChildNode(nodeV2)
        
        let zAlign = SCNNode()
        zAlign.eulerAngles.x = Float(Double.pi/2)
        let cyl = SCNCylinder(radius: radius, height: CGFloat(height / 2))
        cyl.radialSegmentCount = radSegmentCount
        cyl.firstMaterial!.diffuse.contents = color
        let nodeCyl = SCNNode(geometry: cyl )
        nodeCyl.position.y = -height/4
        zAlign.addChildNode(nodeCyl)
        
        addChildNode(zAlign)
        
        constraints = [SCNLookAtConstraint(target: nodeV2)]
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private extension SCNVector3{
    func distance(receiver:SCNVector3) -> Float{
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
}
