//
//  ViewController.swift
//  CachePlay
//
//  Created by wansong.mbp.work on 04/12/2017.
//  Copyright © 2017 wansong.mbp.work. All rights reserved.
//

import UIKit
import ZKUIKit

fileprivate let MP4 = "http://media6.smartstudy.com/29/47/97142/2/dest.mp4"
fileprivate let M3U8 = "http://media6.smartstudy.com/29/47/97142/2/dest.m3u8"

class ViewController: UIViewController {
  
  let mp4 = UIView()
  let m3u8 = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    let offsety0 = 60;
    let dim = 180
    mp4.frame = CGRect(x: 0, y: offsety0, width: dim, height: dim)
    mp4.backgroundColor = .red
    let lbmp4 = UILabel()
    lbmp4.text = "mp4"
    lbmp4.sizeToFit()
    mp4.addSubview(lbmp4)
    
    m3u8.frame = CGRect(x: dim, y: offsety0 + dim, width: dim, height: dim)
    m3u8.backgroundColor = .blue
    let lbm3u8 = UILabel()
    lbm3u8.text = "m3u8"
    lbm3u8.sizeToFit()
    m3u8.addSubview(lbm3u8)
    
    view.addSubview(mp4)
    view.addSubview(m3u8)
    
    let videoBounds = CGRect(x: 0, y: 0, width: dim, height: dim)
    let mp4Video = ZKUIKit.ZKVideoView()
    mp4.addSubview(mp4Video)
    mp4Video.source = MP4
    mp4Video.frame = videoBounds
    mp4Video.playerState = .playing
    mp4Video.containerVC = self
    
    let m3u8Video = ZKUIKit.ZKVideoView()
    m3u8.addSubview(m3u8Video)
    m3u8Video.source = M3U8
    m3u8Video.frame = videoBounds
    m3u8Video.playerState = .playing
    m3u8Video.containerVC = self
  }
}

