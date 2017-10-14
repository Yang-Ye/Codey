//
//  CodeyManager.swift
//  Codey
//
//  Created by Yang Ye on 11/13/16.
//  Copyright © 2016 YY. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc enum Hardness: Int {
    case easy = 0
    case medium = 1
    case hard = 2

    var stringValue: String {
        switch self {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        default:
            return "Hard"
        }
    }
}

class CodeyManger {
    static let sharedInstance = CodeyManger()
    static var soluionFontSize:SolutionTextSize = .small
    var problems: [Problem] = []
    var problemsConstant: [Problem]!
    var coreData: CodeyCoreDataStack?
    var tagKeys:[String] = []
    let hardnessKeys = ["Easy", "Medium", "Hard"]
    var companyKeys: [String] = []
    var themeColor = UIColor.hexStringToUIColor(hex: "F5F5F5")
    var starredProblems: Set<Problem> = []
    var selectedKeys:[Set<String>] = [[],[],[]]
    var hasSelectedKeys: Bool {
        for keyBox in selectedKeys {
            if keyBox.count > 0 {
                return true
            }
        }
        return false
    }

    var lists:[ProblemList]!

    var sortedStarredProblems: [Problem] {
        return starredProblems.sorted(by: { (p1, p2) -> Bool in
            return p1.timeStarred! > p2.timeStarred!
        })
    }

    private init() {
        let time = Date()
        self.coreData = CodeyCoreDataStack()
        self.loadProblem()
        self.loadStarredProblems()
        self.loadAllList()
        self.createKeys()
        let time2 = Date().timeIntervalSince(time)
        print(time2)
    }

    func loadProblem() {
        guard let path = Bundle.main.path(forResource: "AllProblems", ofType: "json") else { return }
        guard let jsonData: Data = NSData(contentsOfFile: path) as Data?  else { return }
        guard let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? Dictionary<String, AnyObject> else{ return }
        guard let jsonProblems = jsonResult?["problems"] as? Dictionary<String, AnyObject> else { return }
        for problem in jsonProblems {
            if let fetchProblems = coreData?.fetchProblem(predicate: NSPredicate(format: "name == %@", argumentArray: [problem.key])) , fetchProblems.count == 1 {
                print("load old problem from json with name \(problem.key)")
                self.problems.append(fetchProblems[0])
            } else {
                if let newProblem = coreData?.makeNewProblem(name: problem.key, value: problem.value as! Dictionary<String, NSObject>){
                    print("load new problem from json with name \(problem.key)")
                    self.problems.append(newProblem)
                }
            }
        }
        self.problems.sort{ return $0.order < $1.order }
        self.problemsConstant = self.problems
    }

    func loadStarredProblems() {
        self.starredProblems = Set(self.problemsConstant.filter({ (problem) -> Bool in
            return problem.isStared
        }))
    }

    func loadAllList() {
        self.lists = self.coreData?.fetchAllLists() ?? []
        self.lists.sort(by: { (list1, list2) -> Bool in
            return list1.createdDate.compare(list2.createdDate as Date) == .orderedAscending})
    }

    func createKeys() {
        var retTagKeys: [String] = []
        var retCompanyKeys: [String] = []
        for problem in self.problemsConstant {
            for tag in problem.tags {
                if !retTagKeys.contains(tag) {
                    retTagKeys.append(tag)
                }
            }

            for company in problem.company {
                if !retCompanyKeys.contains(company) {
                    retCompanyKeys.append(company)
                }
            }
        }
        retTagKeys.sort { return $0 < $1 }
        companyKeys.sort {return $0 < $1}
        self.tagKeys = retTagKeys
        self.companyKeys = retCompanyKeys
    }

    func hardnessString(hardness: Hardness) -> String {
        switch hardness {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }
}

//Fonts
let codeyFont = "ArialRoundedMTBold"

enum SolutionTextSize {
    case small
    case medium
    case large
    case xLarge

    var next: SolutionTextSize {
        switch self {
        case .xLarge:
            return .xLarge
        case .large:
            return .xLarge
        case .medium:
            return .large
        case .small:
            return .medium
        }
    }

    var previous: SolutionTextSize {
        switch self {
        case .xLarge:
            return .large
        case .large:
            return .medium
        case .medium:
            return .small
        case .small:
            return .small
        }
    }
}



extension CodeyManger {
    static func titleCellFont() -> UIFont {
        var size: CGFloat = 0
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            size = 18
        default:
            size = 13
        }
        return UIFont(name: codeyFont, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func textViewCellFontSize() -> CGFloat {
        var size: CGFloat = 0
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            size = 18
        default:
            size = 13
        }
        return size
    }

    static func solutionTextViewFontSize() -> CGFloat {
        var size: CGFloat = 0
        switch self.soluionFontSize {
        case .small:
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                size = 15
            default:
                size = 11
            }
        case .medium:
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                size = 17
            default:
                size = 13
            }
        case .large:
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                size = 19
            default:
                size = 15
            }
        case .xLarge:
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                size = 21
            default:
                size = 17
            }
        }
        return size
    }

    static func solutionCellFont() -> UIFont {
        var size: CGFloat = 0
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            size = 18
        default:
            size = 13
        }
        return UIFont(name: codeyFont, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func tableViewBackgroundColor() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "e2e2e2")
    }

    static func emptyPageInfoSize() -> CGFloat{
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 21
        default:
            return 17
        }
    }
}
