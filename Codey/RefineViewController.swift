//
//  RefineViewController.swift
//  Codey
//
//  Created by Yang Ye on 1/28/17.
//  Copyright © 2017 YY. All rights reserved.
//

import Foundation
import UIKit

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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        dataSource = [codey.hardnessKeys, codey.tagKeys, codey.companyKeys]
        self.selectedKeys = codey.selectedKeys
    }

    func setupNavigationBarItems() {
        let dismissButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Delete"), style: .plain, target: self, action: #selector(dismissSelf))
        dismissButtonItem.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = dismissButtonItem

        let cleanButtonItem = UIBarButtonItem(title: "Clean", style: .plain, target: self, action: #selector(cleanAll))
        cleanButtonItem.tintColor = UIColor.black
        let applyButton = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(applyRefine))
        applyButton.tintColor = UIColor.black

        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = 25

        navigationItem.rightBarButtonItems = [applyButton, spaceItem, cleanButtonItem]
    }

    func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }

    func cleanAll() {
        self.selectedKeys = [Set(), Set(), Set()]
        self.collectionView?.reloadData()
    }

    func applyRefine() {
        if codey.selectedKeys != self.selectedKeys {
            codey.selectedKeys = self.selectedKeys
            self.delegate?.applyButtonTapped()
        } else {
            self.dismissSelf()
        }
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
            cell.background.backgroundColor = UIColor.blueFlat
            cell.title.textColor = UIColor.white
            cell.select = true
        } else {
            cell.background.backgroundColor = UIColor.silverFlat
            cell.title.textColor = UIColor.black
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView?.cellForItem(at: indexPath) as! RefineCell
        if !cell.select {
            cell.select = true
            cell.background.backgroundColor = UIColor.blueFlat
            cell.title.textColor = UIColor.white
            self.selectedKeys[indexPath.section].insert(self.dataSource[indexPath.section][indexPath.row])
        } else {
            cell.select = false
            cell.background.backgroundColor = UIColor.silverFlat
            cell.title.textColor = UIColor.black
            self.selectedKeys[indexPath.section].remove(self.dataSource[indexPath.section][indexPath.row])
        }
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
