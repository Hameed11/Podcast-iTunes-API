//
//  PodcastCell.swift
//  PodcastProject
//
//  Created by Hameed Abdullah on 5/7/19.
//  Copyright © 2019 Hameed Abdullah. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    
    
    var podcast: Podcast! {
        didSet {
            trackNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes"
            
            print("Loading imagess with url:", podcast.artworkUrl600 ?? "")
            
            //7.L Loading + Caching Images with SDWebImage
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            podcastImageView.sd_setImage(with: url, completed: nil)
            
            
//            URLSession.shared.dataTask(with: url) { (data, _, _) in
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                    self.podcastImageView.image = UIImage(data: data)
//
//                }
//            }.resume()
        }
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
