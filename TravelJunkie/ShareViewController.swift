//
//  ShareViewController.swift
//  TravelJunkie
//
//  Created by srivalli kanchibotla on 11/21/16.
//  Copyright © 2016 Tyler Weppler. All rights reserved.
//

import UIKit
import Social
import EVContactsPicker
import SwiftyDropbox
import MessageUI

class ShareViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,DBRestClientDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EVContactsPickerDelegate, MFMailComposeViewControllerDelegate{

        
       
        
    @IBOutlet var tblFiles: UITableView!
        @IBOutlet weak var bbiConnect: UIBarButtonItem!
        
        @IBOutlet weak var progressBar: UIProgressView!
        var imagesDirectoryPath:String!
        var images:[UIImage]!
        var titles:[String]!
        var dbRestClient: DBRestClient!
        var dropboxMetadata: DBMetadata!
        var sharedLinkMetadata =   ""
        var selectedCells: [IndexPath] = [[]]
        var sharables:[String] = [""]
        var shareWith:[String] = [""]
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            
            tblFiles.delegate = self
            tblFiles.dataSource = self
            tblFiles.setEditing(true, animated: true)
            tblFiles.allowsMultipleSelectionDuringEditing = true
            tblFiles.allowsMultipleSelection = true
            
            //  tableView.allowsMultipleSelectionDuringEditing = true
            
            progressBar.isHidden = true
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleDidLinkNotification(notification:)) , name: NSNotification.Name.init(rawValue: "didLinkToDropboxAccountNotification"), object: nil)
            if DBSession.shared().isLinked() {
                bbiConnect.title = "Disconnect"
                initDropboxRestClient()
            }
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        func handleDidLinkNotification(notification: NSNotification) {
            initDropboxRestClient()
            bbiConnect.title = "Disconnect"
        }
        
        // MARK: IBAction method implementation
        
        @IBAction func connectToDropbox(_ sender: AnyObject) {
            if !DBSession.shared().isLinked() {
                DBSession.shared().link(from: self)
                DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                              controller: self,
                                                              openURL: { (url: URL) -> Void in
                                                                UIApplication.shared.openURL(url)
                })
            }
            else if DBSession.shared().isLinked(){
                DBSession.shared().unlinkAll()
                bbiConnect.title = "Connect"
                dbRestClient = nil
            }
        }
        
        
        //creating shared link for selected items
        func restClient(_ restClient: DBRestClient!, loadedSharableLink link: String!, forFile path: String!) {
            sharables.append(link)
            print("sharables\(sharables)")
            print("sharable link \(link)")
        }
        func restClient(_ restClient: DBRestClient!, loadSharableLinkFailedWithError error: Error!) {
            print(error)
        }
        
        @IBAction func shareButton(_ sender: AnyObject) {
            
            let contactPicker = EVContactsPickerViewController()
            
            contactPicker.delegate = self
            self.navigationController?.pushViewController(contactPicker, animated: true)
            
            
            
        }
        
        func didChooseContacts(_ contacts: [EVContactProtocol]?) {
           
          
            if let cons = contacts {
                if let x = tblFiles.indexPathsForSelectedRows{
                for i in tblFiles.indexPathsForSelectedRows!{
                    dbRestClient.loadSharableLink(forFile: "/\(tblFiles.cellForRow(at: i)!.textLabel!.text! as String)")
                    
                }
                }
                else{
                    textAlert(text: "Select atleast one file to share")
                }
                for con in cons {
                    print(con.email)
                    shareWith.append(con.email!)
                }
                
            }
            
            self.navigationController?.popViewController(animated: true)
            shareAlert(text: "Do you want to share the trip details?")
           
            
        }
        
        @IBAction func performAction(_ sender: AnyObject) {
            if !DBSession.shared().isLinked() {
                print("You're not connected to Dropbox")
                textAlert(text: "You're not connected to Dropbox")
                return
            }
            let actionSheet = UIAlertController(title: "Upload file", message: "Select file to upload", preferredStyle: UIAlertControllerStyle.actionSheet)
            let uploadTextFileAction = UIAlertAction(title: "Upload text file", style: UIAlertActionStyle.default) { (action) -> Void in
                let uploadFilename = "testtext.txt"
                let sourcePath = Bundle.main.path(forResource: "testtext", ofType: "txt")
                let destinationPath = "/"
                self.showProgressBar()
                self.dbRestClient.uploadFile(uploadFilename, toPath: destinationPath, withParentRev: nil, fromPath: sourcePath)
                
            }
            
            
            
            let uploadImageFileAction = UIAlertAction(title: "Upload image", style: UIAlertActionStyle.default) { (action) -> Void in
                
                let imagePicker = UIImagePickerController()
               /* if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    self.present(imagePicker, animated: true, completion: nil)
                    
                }*/
               
                    
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    imagePicker.allowsEditing = true
                    
                   self.present(imagePicker, animated: true, completion: nil)
                   
                
             
              
                
                /*  let uploadFilename = "myImageKey.png"
                 let sourcePath = Bundle.main.path(forResource: "myImageKey", ofType: "png")
                 let destinationPath = "/"
                 self.showProgressBar()
                 self.dbRestClient.uploadFile(uploadFilename, toPath: destinationPath, withParentRev: nil, fromPath: sourcePath)*/
                
            }
            
        
          
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
                
            }
            
            actionSheet.addAction(uploadTextFileAction)
            actionSheet.addAction(uploadImageFileAction)
            actionSheet.addAction(cancelAction)
            
            present(actionSheet, animated: true, completion: nil)
            
        }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            let data = UIImagePNGRepresentation(newImage)!
           var file = NSTemporaryDirectory()
          //  var file = temp.appending("newImage.png")
            //UserDefaults.standard.setValue(data, forKey: "newImage")
            do {
                
               // let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let url = NSURL(fileURLWithPath: "\(file)newImage.png")
                try data.write(to: url as URL, options: .atomicWrite)
                
            } catch {
                print("Error")
            }
            
           // let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let destinationPath = "/"
            let sourcePath = "\(file)newImage.png"
            let uploadFilename = "newImage.png"
            self.showProgressBar()
            self.dbRestClient.uploadFile(uploadFilename, toPath: destinationPath, withParentRev: nil, fromPath: sourcePath)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
        @IBAction func reloadFiles(_ sender: AnyObject) {
            dbRestClient.loadMetadata("/")
        }
        
        func initDropboxRestClient() {
            dbRestClient = DBRestClient(session: DBSession.shared())
            dbRestClient.delegate = self
            dbRestClient.loadMetadata("/")
        }
        
        
        func restClient(_ client: DBRestClient!, uploadedFile destPath: String!, from srcPath: String!, metadata: DBMetadata!) {
            print("The file has been uploaded.")
            print(metadata.path)
            textAlert(text: "The file has been uploaded \(metadata.path)")
            progressBar.isHidden = true
            dbRestClient.loadMetadata("/")
        }
        //Error handling delegate method
        func restClient(_ client: DBRestClient!, uploadFileFailedWithError error: Error!) {
            print("File upload failed.")
            print(error)
            textAlert(text: "File upload failed \(error)")
            progressBar.isHidden = true
        }
        
        func showProgressBar() {
            progressBar.progress = 0.0
            progressBar.isHidden = false
        }
        //to display progress bar
        func restClient(_ client: DBRestClient!, uploadProgress progress: CGFloat, forFile destPath: String!, from srcPath: String!) {
            progressBar.progress = Float(progress)
        }
        //to load dropbox contents
        func restClient(_ client: DBRestClient!, loadedMetadata metadata: DBMetadata!) {
            dropboxMetadata = metadata;
            tblFiles.reloadData()
        }
        
        //to display error in loading dropbox contents
        func restClient(_ client: DBRestClient!, loadMetadataFailedWithError error: Error!) {
            textAlert(text: "Display Error: \(error)")
            print(error)
        }
        
        //download the dropbox contents to device
        func restClient(_ client: DBRestClient!, loadedFile destPath: String!, contentType: String!, metadata: DBMetadata!) {
            print("The file \(metadata.filename) was downloaded. Content type: \(contentType)")
            popAlert(text: "The file downloaded")
            progressBar.isHidden = true
        }
        //error handling in content download
        func restClient(_ client: DBRestClient!, loadFileFailedWithError error: Error!) {
            print(error)
            popAlert(text: "Download error: \(error)")
            progressBar.isHidden = true
        }
        //download progress
        func restClient(_ client: DBRestClient!, loadProgress progress: CGFloat, forFile destPath: String!) {
            progressBar.progress = Float(progress)
        }
        func popAlert(text: String) -> Void
        {
            let save = UIAlertController(title: "File Download!", message: text, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (result: UIAlertAction) in
                
            }
            save.addAction(action)
            
            self.present(save, animated: true, completion: nil)
        }
        func textAlert(text: String) -> Void
        {
            let save = UIAlertController(title: "Alert message!", message: text, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (result: UIAlertAction) in
                
            }
            save.addAction(action)
            
            self.present(save, animated: true, completion: nil)
        }
        func shareAlert(text: String) -> Void
        {
            let save = UIAlertController(title: "Alert message!", message: text, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (result: UIAlertAction) in
                /*          print("sharables before share\(self.sharables)")
                 let activityViewController = UIActivityViewController(activityItems: self.sharables, applicationActivities: nil)
                 activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                 
                 
                 // present the view controller
                 self.present(activityViewController, animated: true, completion: nil)*/
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(self.shareWith)
                mail.setSubject("My Trip Details")
                mail.setMessageBody(self.sharables.description, isHTML: true)
                
                
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel){ (result: UIAlertAction) in
                self.sharables.removeAll()
            }
            save.addAction(action)
            save.addAction(cancel)
            
            self.present(save, animated: true, completion: nil)
        }
        // MARK: UITableview method implementation
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if let metadata = dropboxMetadata {
                return metadata.contents.count
            }
            
            return 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "idCellFile", for: indexPath)
            
            let currentFile: DBMetadata = dropboxMetadata.contents[indexPath.row] as! DBMetadata
            cell.textLabel?.text = currentFile.filename
            
            return cell
        }
        
        @IBAction func download(_ sender: AnyObject) {
            if !DBSession.shared().isLinked() {
                print("You're not connected to Dropbox")
                textAlert(text: "You're not connected to Dropbox")
                return
            }
            else{
            if tblFiles.indexPathsForSelectedRows?.count == nil{
                textAlert(text: "Select atleast one file to download")
            }
           else{
            for x in tblFiles.indexPathsForSelectedRows!{
                let selectedFile: DBMetadata = dropboxMetadata.contents[x.row] as! DBMetadata
                
                let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
                let localFilePath = documentsDirectoryPath.appendingPathComponent(selectedFile.filename)
                
                print("The file to download is at: \(selectedFile.path)")
                print("The documents directory path to download to is : \(documentsDirectoryPath)")
                print("The local file should be: \(localFilePath)")
                
                
                showProgressBar()
                
                dbRestClient.loadFile(selectedFile.path, intoPath: documentsDirectoryPath as String)
            }
            }
            }
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60.0
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(indexPath)
            
            
        }
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
        
    }
        
        
        
    


}
