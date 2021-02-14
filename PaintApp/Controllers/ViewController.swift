//
//  ViewController.swift
//  PaintApp
//
//  Created by Meruyert Tastandiyeva on 2/14/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var undoButton: UIButton!
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    var brushSize: CGFloat = 5.0
    var opacityValue: CGFloat = 1.0
    
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
        if drawView.fillIsSelected {
            drawView.fillIsSelected = false
        } else {
            drawView.fillIsSelected = true
        }
    }
    
    @IBAction func circleButtonPressed(_ sender: Any) {
        if drawView.circleIsSelected {
            drawView.circleIsSelected = false
        } else {
            drawView.circleIsSelected = true
            setStyle()
        }
    }
    
    @IBAction func lineButtonPressed(_ sender: Any) {
        if drawView.lineIsSelected {
            drawView.lineIsSelected = false
        } else {
            drawView.lineIsSelected = true
            setStyle()
        }
    }
    
    @IBAction func rectangleButtonPressed(_ sender: Any) {
        if drawView.rectIsSelected {
            drawView.rectIsSelected = false
        } else {
            drawView.rectIsSelected = true
            setStyle()
        }
    }
    
    @IBAction func triangleButtonPressed(_ sender: Any) {
        if drawView.triangleIsSelected {
            drawView.triangleIsSelected = false
        } else {
            drawView.triangleIsSelected = true
            setStyle()
        }
    }
    
    @IBAction func penButtonPressed(_ sender: Any) {
        if drawView.penIsSelected {
            drawView.penIsSelected = false
        } else {
            drawView.penIsSelected = true
            setStyle()
        }
    }
    
    func setStyle() {
        drawView.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: opacityValue))
        drawView.setStrokeWidth(brushSize)
    }
    
    @objc func tap() {
        drawView.undoAction()
        print("Tap happend")
    }

    @objc func long() {
        drawView.clearAction()
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
        drawView.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: opacityValue))
        drawView.setStrokeWidth(brushSize)
    }
}
