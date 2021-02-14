//
//  ViewController.swift
//  PaintApp
//
//  Created by Meruyert Tastandiyeva on 2/14/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var drawView: SketchView!
    @IBOutlet weak var undoButton: UIButton!
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    var brushSize: CGFloat = 5.0
    var opacityValue: CGFloat = 1.0
    
    var fillIsSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tap))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))
        tapGesture.numberOfTapsRequired = 1
        undoButton.addGestureRecognizer(tapGesture)
        undoButton.addGestureRecognizer(longGesture)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let settingsVC = segue.destination as! SettingsViewController
        settingsVC.delegate = self
        settingsVC.red = red
        settingsVC.green = green
        settingsVC.blue = blue
        settingsVC.brushSize = brushSize
        settingsVC.opacityValue = opacityValue
    }
    
    @IBAction func colorButtonPressed(_ sender: AnyObject) {
        if sender.tag == 0 {
            (red,green,blue) = (1,0,0)
        } else if sender.tag == 1 {
            (red,green,blue) = (0,1,0)
        } else if sender.tag == 2 {
            (red,green,blue) = (0,0,1)
        } else if sender.tag == 3 {
            (red,green,blue) = (1,0,1)
        } else if sender.tag == 4 {
            (red,green,blue) = (1,1,0)
        } else if sender.tag == 5 {
            (red,green,blue) = (0,1,1)
        } else if sender.tag == 6 {
            (red,green,blue) = (1,1,1)
        } else if sender.tag == 7 {
            (red,green,blue) = (0,0,0)
        }
        setStyle()
    }
    
    @IBAction func switchPressed(_ sender: Any) {
        if fillIsSelected {
            fillIsSelected = false
        } else {
            fillIsSelected = true
        }
    }
    
    @IBAction func circleButtonPressed(_ sender: Any) {
        if fillIsSelected {
            drawView.drawTool = .ellipseFill
        } else {
            drawView.drawTool = .ellipseStroke
        }
        setStyle()
    }
    
    @IBAction func lineButtonPressed(_ sender: Any) {
        drawView.drawTool = .line
        setStyle()
    }
    
    @IBAction func rectangleButtonPressed(_ sender: Any) {
        if fillIsSelected {
            drawView.drawTool = .rectangleFill
        } else {
            drawView.drawTool = .rectangleStroke
        }
        setStyle()
    }
    
    @IBAction func triangleButtonPressed(_ sender: Any) {
        if fillIsSelected {
            drawView.drawTool = .triangleFill
        } else {
            drawView.drawTool = .triangleStroke
        }
        setStyle()
    }
    
    @IBAction func penButtonPressed(_ sender: Any) {
        drawView.drawTool = .pen
        setStyle()
    }
    
    func setStyle() {
        drawView.lineColor = UIColor(red: red, green: green, blue: blue, alpha: opacityValue)
        drawView.lineWidth = brushSize
    }
    
    @objc func tap() {
        drawView.undo()
        print("Tap happend")
    }

    @objc func long() {
        drawView.clear()
        print("Long press")
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
}

extension ViewController: SettingsDelegate {
    func settingsViewControllerDidFinish(_ settingsVC: SettingsViewController) {
        self.red = settingsVC.red
        self.green = settingsVC.green
        self.blue = settingsVC.blue
        self.brushSize = settingsVC.brushSize
        self.opacityValue = settingsVC.opacityValue
        setStyle()
    }
}
