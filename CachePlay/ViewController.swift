//
//  ViewController.swift
//  CachePlay
//
//  Created by wansong.mbp.work on 04/12/2017.
//  Copyright © 2017 wansong.mbp.work. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let mp4 = UIView()
  let m3u8 = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    let offsety0 = 60;
    mp4.frame = CGRect(x: 0, y: offsety0, width: 100, height: 100)
    mp4.backgroundColor = .red
    let lbmp4 = UILabel()
    lbmp4.text = "mp4"
    lbmp4.sizeToFit()
    mp4.addSubview(lbmp4)
    
    m3u8.frame = CGRect(x: 100, y: offsety0 + 100, width: 100, height: 100)
    m3u8.backgroundColor = .blue
    let lbm3u8 = UILabel()
    lbm3u8.text = "m3u8"
    lbm3u8.sizeToFit()
    m3u8.addSubview(lbm3u8)
    
    view.addSubview(mp4)
    view.addSubview(m3u8)
  }
}

