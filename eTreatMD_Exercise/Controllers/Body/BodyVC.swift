//
//  BodyVC.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import UIKit

class BodyVC: UIViewController {
    //-----------------
    // MARK: - Enum
    //-----------------
    enum Joints: Int {
        case Neck = 1, Chest, Waist, RightJaw, LeftJaw, RightShoulder, LeftShoulder, RightElbow, LeftElbow, RightHand, LeftHand, RightHip, LeftHip, RightKnee, LeftKnee, RightAnkle, LeftAnkle, RightFoot, LeftFoot
        
        var description: String {
            switch self {
            case .Neck: return "Neck"
            case .Chest: return "Chest"
            case .Waist: return "Waist"
            case .RightJaw: return "Right Jaw"
            case .LeftJaw: return "Left Jaw"
            case .RightShoulder: return "Right Shoulder"
            case .LeftShoulder: return "Left Shoulder"
            case .RightElbow: return "Right Elbow"
            case .LeftElbow: return "Left Elbow"
            case .RightHand: return "Right Hand"
            case .LeftHand: return "Left Hand"
            case .RightHip: return "Right Hip"
            case .LeftHip: return "Left Hip"
            case .RightKnee: return "Right Knee"
            case .LeftKnee: return "Left Knee"
            case .RightAnkle: return "Right Ankle"
            case .LeftAnkle: return "Left Ankle"
            case .RightFoot: return "Right Foot"
            case .LeftFoot: return "Left Foot"
            }
        }
    }

    //-----------------
    // MARK: - UIOutlets
    //-----------------
    @IBOutlet weak var bodyImageView: UIImageView! {
        didSet {
            bodyImageView.loadImage(withURLString: "https://test.livewithacne.com/media/steps/Body.png", withDefaultImage: UIImage(named: "Body"))
        }
    }
    @IBOutlet var joints: [UIView]! {
        didSet {
            for joint in joints {
                joint.backgroundColor = .white
                joint.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(jointTapped(sender:))))
            }
        }
    }
    
    //-----------------
    // MARK: - Init
    //-----------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//-----------------
// MARK: - Touches
//-----------------
extension BodyVC {
    @objc func jointTapped(sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        for joint in joints {
            if joint == view {
                joint.backgroundColor = .blue
            } else {
                joint.backgroundColor = .white
            }
        }
        guard let joint = Joints.init(rawValue: view.tag) else { return }
        print("You have selected: \(joint.description)")
    }
}
