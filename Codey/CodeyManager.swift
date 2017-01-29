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

class CodeyManger {
    static let sharedInstance = CodeyManger()
    var problems: [Problem] = []
    var problemPool: [Problem]!
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
                return false
            }
        }
        return true
    }

    private init() {
        let time = Date()
        self.coreData = CodeyCoreDataStack()
        self.loadProblem()
        self.loadStarredProblems()
        self.createKeys()
        let time2 = Date().timeIntervalSince(time)
        print(time2)
    }

    func loadProblem() {
        guard let path = Bundle.main.path(forResource: "AllProblems", ofType: "json") else { return }
        guard let jsonData: Data = NSData(contentsOfFile: path) as? Data  else { return }
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
        self.problemPool = self.problems
    }

    func loadStarredProblems() {
        self.starredProblems = Set(self.problems.filter({ (problem) -> Bool in
            return problem.isStared
        }))
    }

    func createKeys() {
        var retTagKeys: [String] = []
        var retCompanyKeys: [String] = []
        for problem in self.problems {
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

    func loadFilteredProblems(key: Set<String>) {
        self.problemPool = self.problemPool.filter({ (problem) -> Bool in
            for aKey in key {
                if problem.tags.contains(aKey) {
                    return true
                }
            }
            return false
        })
    }

    func resetProblemPool() {
        self.problemPool = self.problems
    }

    func sortProblems(key: String) {
        if key == "Alphabetic" {
            self.problemPool.sort(by: { (p1, p2) -> Bool in
                return p1.name < p2.name
            })
        } else if key == "Easy → Hard" {
            self.problemPool.sort(by: { (p1, p2) -> Bool in
                return p1.hardness < p2.hardness
            })
        } else if key == "Hard → Easy" {
            self.problemPool.sort(by: { (p1, p2) -> Bool in
                return p1.hardness > p2.hardness
            })
        }
    }

    func hardnessString(hardness: Int) -> String {
        if hardness == 0 {
            return "Easy"
        } else if hardness == 1 {
            return "Medium"
        } else {
            return "Hard"
        }
    }
}
