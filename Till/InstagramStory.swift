//
//  InstagramStory.swift
//  Till
//
//  Created by Isis Ramirez on 30/03/20.
//  Copyright © 2020 Isis Ramirez. All rights reserved.
//

import Foundation
import UIKit

class InstagramStory: UIView {
    @IBOutlet var container: UIView!
    @IBOutlet var background: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var countdown: UILabel!
    @IBOutlet var date: UILabel!

    //MARK: - View
    var nibName = "InstagramStory"

    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNib()
    }
    
    func initNib() {
        _ = subviews.map { $0.removeFromSuperview() }
        let bundle = Bundle(for: InstagramStory.self)
        bundle.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(container)
        container.frame = CGRect(x: 0, y: 0, width: 360, height: 640)
    }
    
    func setBackground(image: UIImage) {
        background.image = image
        background.contentMode = .scaleAspectFill
    }
    
    func setData(event: Event) {
        title.text = event.name
        countdown.text = event.daysUntil()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        date.text = dateFormatter.string(from: event.date!)
    }
}
