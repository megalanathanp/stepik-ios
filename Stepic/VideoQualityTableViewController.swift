//
//  VideoQualityTableViewController.swift
//  Stepic
//
//  Created by Alexander Karpov on 22.10.15.
//  Copyright © 2015 Alex Karpov. All rights reserved.
//

import UIKit

enum VideoQualityChoiceAction: Int {
    case downloading = 0, watching

    var title: String {
        switch self {
        case .downloading:
            return NSLocalizedString("LoadingVideoQualityPreference", comment: "")
        case .watching:
            return NSLocalizedString("WatchingVideoQualityPreference", comment: "")
        }
    }
}

class VideoQualityTableViewController: UITableViewController {

    @IBOutlet var qualityCells: [UITableViewCell]!

    @IBOutlet weak var lowLabel: StepikLabel!
    @IBOutlet weak var mediumLabel: StepikLabel!
    @IBOutlet weak var highLabel: StepikLabel!
    @IBOutlet weak var veryHighLabel: StepikLabel!

    var action: VideoQualityChoiceAction!

    let defaultQualities = ["270", "360", "720", "1080"]
    let qualityStrings = [
        NSLocalizedString("Low", comment: ""),
        NSLocalizedString("Medium", comment: ""),
        NSLocalizedString("High", comment: ""),
        NSLocalizedString("VeryHigh", comment: "")
    ]

    fileprivate func localize() {
        lowLabel.text = "\(qualityStrings[0]) (\(defaultQualities[0])p)"
        mediumLabel.text = "\(qualityStrings[1]) (\(defaultQualities[1])p)"
        highLabel.text = "\(qualityStrings[2]) (\(defaultQualities[2])p)"
        veryHighLabel.text = "\(qualityStrings[3]) (\(defaultQualities[3])p)"
        title = NSLocalizedString("VideoQuality", comment: "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        localize()
        tableView.tableFooterView = UIView()
        self.title = action.title

        #if swift(>=3.2)
            if #available(iOS 11.0, *) {
                tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            }
        #endif
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        setCheckmarkTo(defaultQualities.index(of: (action == .downloading ? VideosInfo.downloadingVideoQuality : VideosInfo.watchingVideoQuality)) ?? 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setQualutyTo(quality: String) {
        switch action! {
        case VideoQualityChoiceAction.downloading:
            VideosInfo.downloadingVideoQuality = quality
            return
        case VideoQualityChoiceAction.watching:
            VideosInfo.watchingVideoQuality = quality
            return
        }
    }

}

extension VideoQualityTableViewController {

    fileprivate func setCheckmarkTo(_ selectedTag: Int) {
        for cell in qualityCells {
            if cell.tag == selectedTag {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filtered = qualityCells.filter({return $0.tag == (indexPath as NSIndexPath).row})
        switch filtered.count {
        case 0:
            print("error! selected a video quality cell without a tag!")
        case 1:
            setQualutyTo(quality: defaultQualities[filtered[0].tag])
            setCheckmarkTo(filtered[0].tag)
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            print("something wrong happened during selection in videoQualityTableViewController")
        }
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
