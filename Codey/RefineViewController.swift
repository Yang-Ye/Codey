//
//  RefineViewController.swift
//  Codey
//
//  Created by Yang Ye on 1/28/17.
//  Copyright © 2017 YY. All rights reserved.
//

import Foundation

protocol RefineViewControllerDelegate: class {
    func applyButtonTapped()
}

class RefineViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    weak var delegate: RefineViewControllerDelegate?
    var codey: CodeyManger = CodeyManger.sharedInstance
    var layout: UICollectionViewFlowLayout!
    var dataSource:[[String]]!
    var selectedKeys:[Set<String>]!

    init() {
        layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }

    override func viewDidLoad() {
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.register(UINib.init(nibName: "RefineCell", bundle: nil) , forCellWithReuseIdentifier: "RefineCell")
        self.collectionView?.register(UINib.init(nibName: "RefineHeaderCell", bundle: nil) , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "RefineHeaderCell")
        self.setupNavigationBarItems()
        layout.headerReferenceSize = CGSize(width: self.collectionView!.frame.size.width, height: 50)
        layout.estimatedItemSize = CGSize(width: 50, height: 30)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        dataSource = [codey.hardnessKeys, codey.tagKeys, codey.companyKeys]
        self.selectedKeys = codey.selectedKeys
    }

    func setupNavigationBarItems() {
        let backButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissSelf))
        backButtonItem.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = backButtonItem

        let applyButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(applyRefine))
        applyButton.tintColor = UIColor.black
        navigationItem.rightBarButtonItems = [applyButton]
    }

    func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }

    func applyRefine() {
        if codey.selectedKeys != self.selectedKeys {
            codey.selectedKeys = self.selectedKeys
            self.delegate?.applyButtonTapped()
        }
        self.dismissSelf()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been imple mented")
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RefineCell", for: indexPath) as! RefineCell
        let text = dataSource[indexPath.section][indexPath.row]
        cell.title.text = text
        if self.selectedKeys[indexPath.section].contains(text) {
            cell.background.backgroundColor = UIColor.red
            cell.select = true
        } else {
            cell.background.backgroundColor = UIColor.blueFlat
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView?.cellForItem(at: indexPath) as! RefineCell
        if !cell.select {
            cell.select = true
            cell.background.backgroundColor = UIColor.red
            self.selectedKeys[indexPath.section].insert(self.dataSource[indexPath.section][indexPath.row])
        } else {
            cell.select = false
            cell.background.backgroundColor = UIColor.blueFlat
            self.selectedKeys[indexPath.section].remove(self.dataSource[indexPath.section][indexPath.row])
        }
        print(self.selectedKeys)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "RefineHeaderCell", for: indexPath) as! RefineHeaderCell
        switch indexPath.section {
        case 0:
            headerView.text.text = "Hardness"
        case 1:
            headerView.text.text = "Tag"
        default:
            headerView.text.text = "Company"
        }
        return headerView
    }
}
