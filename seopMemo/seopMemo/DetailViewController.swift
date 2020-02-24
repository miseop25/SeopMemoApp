//
//  DetailViewController.swift
//  seopMemo
//
//  Created by Minseop Kim on 2020/02/21.
//  Copyright © 2020 Minseop Kim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var memo: Memo?
    
    @IBOutlet weak var memoTableView: UITableView!
    
    
    let formatter: DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    @IBAction func delectMemo(_ sender: Any) {
        let alert = UIAlertController(title: "삭제 확인", message: "메모를 삭제할까요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "삭제", style: .destructive){
            [weak self] (action) in
            DataManager.shared.delectMemo(self?.memo)
            self?.navigationController?.popViewController(animated: true)
            
            
        }
        
        alert.addAction(okAction)
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancleAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController{
            vc.editTarget = memo
        }
    }

    var token: NSObjectProtocol?
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidChange, object: nil, queue: OperationQueue.main, using: {[weak self ] (noti) in self?.memoTableView.reloadData()})

    }


}


extension DetailViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
            
            cell.textLabel?.text = memo?.memoTitle
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
            
            cell.textLabel?.text = memo?.content
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
            if  let images = memo?.memoImage {
                cell.imageView?.image = UIImage(data: images)
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            
            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
            return cell
            
        default:
            fatalError()
        }
    }
    
    
}
