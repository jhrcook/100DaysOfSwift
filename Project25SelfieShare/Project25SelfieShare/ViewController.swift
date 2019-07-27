//
//  ViewController.swift
//  Project25SelfieShare
//
//  Created by Joshua on 7/25/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate {
    
    var images = [UIImage]()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Selfie Share"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        
        // start multipeer connection
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        return cell
    }
    
    
    @objc func showConnectionPrompt() {
        let alertController = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        alertController.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        if mcSession != nil {
            if mcSession!.connectedPeers.count > 0 {
                alertController.addAction(UIAlertAction(title: "Show all peers", style: .default, handler: showConnectedPeers))
            }
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    
    func startHosting(_ alert: UIAlertAction) {
        if mcSession == nil { return }
        
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession!)
        mcAdvertiserAssistant?.start()
    }
    
    
    func joinSession(_ alert: UIAlertAction) {
        if mcSession == nil { return }
        
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession!)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    
    func showConnectedPeers(_ alert: UIAlertAction) {
        if mcSession != nil {
            var peersDisplayNames = [String]()
            for peer in mcSession!.connectedPeers { peersDisplayNames.append(peer.displayName) }
            let alertController = UIAlertController(title: "Connected peers", message: peersDisplayNames.joined(separator: ", "), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
    }
    
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // save selected image
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        // share image
        if mcSession == nil { return }
        if mcSession!.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try mcSession!.send(imageData, toPeers: mcSession!.connectedPeers, with: .reliable)
                } catch {
                    print("Error in sending data -- error message:")
                    print(error.localizedDescription)
                    print("----------")
                    let alertController = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alertController, animated: true)
                }
            }
        }
    }
    
    
    // ---- Conforming to MC ---- //

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // used for diagnositc purposes
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not connected: \(peerID.displayName)")
            let alertController = UIAlertController(title: "Disconnected", message: "\(peerID.displayName) has disconnected", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        @unknown default:
            print("unknown state of peer: \(peerID.displayName)")
        }
    }
    
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // recieve an image from peer
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // ignore //
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // ignore //
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // ignore //
    }

}

