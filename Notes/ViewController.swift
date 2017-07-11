//
//  ViewController.swift
//  Notes
//
//  Created by Manas on 11/07/17.
//  Copyright © 2017 Manas. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    var noteDicts: Results<NoteData>?
    var searchResults: Results<NoteData>?
    let searchController = UISearchController(searchResultsController: nil)
    var shouldShowSearchResults = false
    var inSearch = false
    let realm = try! Realm()
    var isWithPriority = false
    let priorityArray = ["Low", "Mid", "High"]


    @IBOutlet weak var noteList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        noteList.delegate = self
        noteList.dataSource = self
        noteList.separatorStyle = .none
        configureSearchController()
        fetchData()
        
    }
    func fetchData() {
        if isWithPriority{
            var newDict = realm.objects(NoteData.self).sorted(byKeyPath: "priorityOfNote", ascending: false)
            noteDicts = newDict
            
        }
        else{
            noteDicts = realm.objects(NoteData.self).sorted(byKeyPath: "dateUpdated", ascending: false)
        }
        noteList.reloadData()
        
    }
    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        noteList.tableHeaderView = searchController.searchBar
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        noteList.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        let resultPredicate = NSPredicate(format: "self.title contains[c] %@", searchString!)
        searchResults = noteDicts?.filter(resultPredicate)
        
        if((searchResults?.count)! > 0){
            shouldShowSearchResults = true
        }
        print(searchResults?.count)
        noteList.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults{
            return searchResults!.count
        }
        if noteDicts != nil{
            return (noteDicts?.count)!
        }
        else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var noteDictArray = noteDicts
        if shouldShowSearchResults{
            noteDictArray = searchResults
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
        cell.tagLabel.text = noteDictArray?[indexPath.row].title
        cell.priority.text = priorityArray[(noteDictArray?[indexPath.row].priorityOfNote)!]
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd, hh:mm a"
        let dateString = format.string(from: (noteDictArray?[indexPath.row].dateUpdated)!)
      
        cell.updatedAt.text = dateString
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        if shouldShowSearchResults{
            vc.noteDict = searchResults?[indexPath.row]
        }
        else{
            vc.noteDict = noteDicts?[indexPath.row]
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    

    @IBAction func sortTheList(_ sender: UIBarButtonItem) {
        if sender.tintColor == UIColor.lightGray {
            sender.tintColor = UIColor.black
            isWithPriority = false
            fetchData()
        }
        else{
            sender.tintColor = UIColor.lightGray
            isWithPriority = true
            fetchData()
        }
    }
    
    @IBAction func addNew(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}














