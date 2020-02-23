//
//  ComposeViewController.swift
//  seopMemo
//
//  Created by Minseop Kim on 2020/02/20.
//  Copyright © 2020 Minseop Kim. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var editTarget: Memo?
    var originalMemoContent: String?
    var originalMemoTitle: String?
    

    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var memoTitleField: UITextField!
    @IBOutlet weak var memoImageView: UIImageView!
    
    
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
        guard let memo = memoTextView.text, memo.count > 0 else {
            alert(message: "메모를 입력하세요")
            return
        }
        
        guard let memoTitle = memoTitleField.text, memoTitle.count > 0 else{
            alert(message: "제목을 입력하세요")
            return
        }
        
        
        if let target = editTarget{
            target.content = memo
            target.memoTitle = memoTitle
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name : ComposeViewController.memoDidChange ,object: nil)
        }else {
            DataManager.shared.addNewMemo(memo, memoTitle)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)

        }
        
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo = editTarget{
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
            memoTitleField.text = memo.memoTitle
            originalMemoContent = memo.content
            originalMemoTitle = memo.memoTitle
            
        }else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
        
        
            }
    
    @IBAction func pickImageButton(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "사진 추가", message: "어느곳에서 사진을 가져오시겠습니까?", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "사진 촬영", style: .default){ (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let photoLibaryAction = UIAlertAction(title: "사진 보관함", style: .default){
            (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        let savedPhotoAction = UIAlertAction(title: "저장된 사진", style: .default){
            (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true,  completion: nil)
        }
        
        
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(photoLibaryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(savedPhotoAction)
        alertController.addAction(cancleAction)
        
        present(alertController, animated: true, completion: nil)
        
        
        
        
    }
    

}






extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidChange = Notification.Name(rawValue: "memDidChange")
}
