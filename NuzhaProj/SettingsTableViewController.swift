//
//  SettingsTableViewController.swift
//  NuzhaProj
//
//  Created by Mims on 09/07/2019.
//  Copyright © 2019 Mims. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices
class SettingsTableViewController: UITableViewController {

    @IBAction func Dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var privacypolicy: UITextView!
    var textPrivacy : String?
    @IBOutlet var SetTable: UITableView!
    @IBOutlet weak var HowIsUs: UITextView!
    var textWrit :String?
    override func viewDidLoad() {
        super.viewDidLoad()
textWrit = "يهدف التطبيق الى التعريف بمناطق المملكة وومعالمها السياحية والتاريخية لسكان المملكة وخارجها واستكشاف الأماكن فيها وتقديم النصائح للسائح نرحب بأي دعم مقدم سواء بمشاركتنا عن المناطق او اطافة اقتراحاتكم الى التطبيق عبر الضغط على ايقونة (تواصل معنا)"
        
        HowIsUs.text = textWrit
        SetTable.tableFooterView = UIView(frame: CGRect(x: 10, y: 100, width: 100, height: 80))
        SetTable.sectionHeaderHeight = 40.0
textPrivacy = "المحتوى النصي والمرئي قد يشمل على أخطاء وهو قيد المراجعة والتطوير والتدقيق ومراجعة حقوق الملكية، وفي حال وجود أي استفسار أو اعتراضات يرجى مراسلتنا من خلال الايميل"
        privacypolicy.text = textPrivacy
    }
    @IBAction func MailMe(_ sender: Any) {
        showMailComposer()
    }
    @IBAction func IstgMe(_ sender: Any) {
        showSafariVC(for: "https://www.instagram.com")
    }
    @IBAction func TwittMe(_ sender: Any) {
        showSafariVC(for: "https://twitter.com/NuzhahApp")
    }
    //safari
    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            //Show an invalid URL error alert
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    ///Emai
    func showMailComposer() {
        
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing the user
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self as! MFMailComposeViewControllerDelegate
        composer.setToRecipients(["najd995z@gmail.com"])
        composer.setSubject("!")
        composer.setMessageBody("Type something", isHTML: false)
        present(composer, animated: true)
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            //Show error alert
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        }
        controller.dismiss(animated: true)
    }
}
