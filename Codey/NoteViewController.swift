//
//  NoteViewController.swift
//  
//
//  Created by Yang Ye on 4/23/17.
//
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {

    var problem: Problem!
    @IBOutlet var note: UITextView!
    @IBOutlet var lastEdit: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        note.layer.cornerRadius = problemDetailViewCornerRadius
        setupNavigationBarItems()
        if let notetext = problem.note {
            note.text = notetext
        } else {
            self.note.becomeFirstResponder()
        }

        if let lastEditTime = problem.lastEditNote {
            let dateFormator = DateFormatter()
            dateFormator.dateStyle = .short
            lastEdit.text = "Last edit: " + dateFormator.string(from: lastEditTime)
        }
    }

    func setupNavigationBarItems() {
        self.navigationController?.navigationBar.barTintColor = .white

        let saveButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(dismissSelf))
        saveButtonItem.tintColor = UIColor.black

        navigationItem.rightBarButtonItem = saveButtonItem

        let cleanNoteButtonItem = UIBarButtonItem(title: "Clean", style: .plain, target: self, action: #selector(cleanNote))
        cleanNoteButtonItem.tintColor = UIColor.black

        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = 12

        navigationItem.leftBarButtonItem = cleanNoteButtonItem
    }

    func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }

    func cleanNote() {
        note.text = ""
        problem.note = nil
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.contentInset = UIEdgeInsetsMake(0, 0, self.view.height*2/5, 0)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != "" {
            problem.lastEditNote = Date()
            problem.note = textView.text
        } else {
            problem.lastEditNote = nil
            problem.note = nil
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        note.resignFirstResponder()
    }
}
