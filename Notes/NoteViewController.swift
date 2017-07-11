//
//  NoteViewController.swift
//  Notes
//
//  Created by Manas on 11/07/17.
//  Copyright © 2017 Manas. All rights reserved.
//

import UIKit
import RealmSwift

class NoteViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    @IBOutlet weak var priorityButton: UIButton!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var priorityTableView: UITableView!
    @IBOutlet var singleTapOnView: UITapGestureRecognizer!

    var noteDict: NoteData?
    var priorityOfNote = 1
    var isNew: Bool = true
    let realm = try! Realm()
    let priorityArray = ["Low", "Mid", "High"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        priorityTableView.isHidden = true
        singleTapOnView.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        titleTF.delegate = self
        titleTF.layer.borderColor = UIColor.clear.cgColor
        detail.delegate = self
        singleTapOnView.delegate = self
        deleteButton.isEnabled = false
        if noteDict != nil{
            isNew = false
            titleTF.text = noteDict?.title
            detail.text = noteDict?.detail
            deleteButton.isEnabled = true
            priorityOfNote = (noteDict?.priorityOfNote)!
        }
        priorityButton.setTitle("Prio: \(priorityArray[priorityOfNote]) ", for: .normal)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
    }
    
    
    func saveNote() {
        var titleText = titleTF.text
        let updateDate = Date()
        if titleTF.text == ""{
            titleText = "Untitled\(updateDate)"
        }
        if isNew && detail.text != ""{
            noteDict = NoteData()
            noteDict?.title = titleText!
            noteDict?.detail = detail.text
            noteDict?.dateUpdated = updateDate
            noteDict?.priorityOfNote = priorityOfNote
            try! realm.write {
                realm.add(noteDict!)
            }
        }
        else if detail.text != "" && !isNew{
            try! realm.write {
                noteDict?.title = titleText!
                noteDict?.detail = detail.text
                noteDict?.dateUpdated = updateDate
                noteDict?.priorityOfNote = priorityOfNote
            }
        }
        else{
            noteDict = nil
        }
    }
    

    
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if detail.text != "" && !isNew{
            try! realm.write {
                realm.delete(noteDict!)
                navigationController?.popViewController(animated: true)
            }
        }
        
    }
    @IBAction func onSingleTap(_ sender: Any) {
        priorityTableView.isHidden = true
        singleTapOnView.isEnabled = false
        
    }
    
    @IBAction func setPriority(_ sender: Any) {
        priorityTableView.isHidden = false
        priorityTableView.delegate = self
        priorityTableView.dataSource = self
        priorityTableView.reloadData()
        singleTapOnView.isEnabled = true
    }
    @IBAction func backToList(_ sender: Any) {
        saveNote()
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PriorityCell", for: indexPath)
       cell.textLabel?.text = priorityArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        priorityOfNote = indexPath.row
        priorityButton.setTitle("Prio: \(priorityArray[indexPath.row]) ", for: .normal)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if let view = touch.view
        {
            if view.isDescendant(of: priorityTableView)
            {
                return false
            }
        }
        priorityTableView.isHidden = true
        return true
    }
    //When keyboard will show
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            detail.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
            detail.scrollIndicatorInsets = detail.contentInset
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            detail.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            detail.scrollIndicatorInsets = detail.contentInset
            }
    }

}





















