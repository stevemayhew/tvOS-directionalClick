//
//  ViewController.swift
//  tvOS-directionalClick
//
//  Created by David Cordero on 10.07.17.
//  Copyright © 2017 David Cordero. All rights reserved.
//

import UIKit
import GameController

class ViewController: UIViewController {

    @IBOutlet private weak var directionLabel: UILabel!
    
    private var dPadState: DPadState = .select

    private var padNeedsSetup: Bool = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
        if padNeedsSetup {
            setUpDirectionalPad()
            padNeedsSetup = false
        }
        print("pressesBegan: \(dPadState)")

        for press in presses {
            switch press.type {
            case .select where dPadState == .up:
                directionLabel.text = "⬆️"
            case .select where dPadState == .down:
                directionLabel.text = "⬇️"
            case .select where dPadState == .left:
                directionLabel.text = "⬅️"
            case .select where dPadState == .right:
                directionLabel.text = "➡️"
            case .select:
                directionLabel.text = "🆗"
            default:
                super.pressesBegan(presses, with: event)
            }
        }
        directionLabel.setNeedsDisplay()
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        print("pressesEnded: \(dPadState)")
    }
    
    // MARK: - Private
    
    private func setUpDirectionalPad() {
        guard let controller = GCController.controllers().first else { return }
        guard let micro = controller.microGamepad else { return }
        micro.reportsAbsoluteDpadValues = true
        micro.dpad.valueChangedHandler = {
            [weak self] (pad, x, y) in
            
            if (abs(x) > 0.0 && abs(y) > 0.0) {
                print("x/y \(x) \(y)")
                let threshold: Float = 0.7
                if abs(y) > threshold {
                    if y > 0.0 {
                        self?.dPadState = .up
                    } else {
                        self?.dPadState = .down
                    }
                } else if abs(x) > threshold {
                    if x > 0.0 {
                        self?.dPadState = .right
                    } else {
                        self?.dPadState = .left
                    }
                } else {
                    self?.dPadState = .select
                }
            }
        }
    }
}

