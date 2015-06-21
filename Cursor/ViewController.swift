//
//  ViewController.swift
//  Cursor
//
//  Created by Brabeeba Wang on 12/2/14.
//  Copyright (c) 2014 Brabeeba Wang. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, UIGestureRecognizerDelegate  {
    //self-defined prototype
    let serviceType = "brabeeba"
    
    //here we make framework to handle the advertising and browsing process
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    var session: MCSession!
    var peerID: MCPeerID!
    
    
    
    //execute after the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize all the Multipeer objects
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        self.browser = MCBrowserViewController(serviceType:serviceType, session:self.session)
        self.browser.delegate = self
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType, discoveryInfo:nil, session:self.session)
        //advertising
        self.assistant.start()
    }
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        let message="tap"
        //we encode the string into NSData
        let msg=message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        var error : NSError?
        //we send the data to every peer that is connected to us in the session
        self.session.sendData(msg, toPeers: self.session.connectedPeers,
            withMode: MCSessionSendDataMode.Unreliable, error: &error)
        if error != nil {
            print("Error sending data: \(error?.localizedDescription)")
        }
    }
    @IBAction func swipeThreeUp(sender: UISwipeGestureRecognizer) {
        let message="swipeThreeUp"
        //we encode the string into NSData
        let msg=message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        var error : NSError?
        //we send the data to every peer that is connected to us in the session
        self.session.sendData(msg, toPeers: self.session.connectedPeers,
            withMode: MCSessionSendDataMode.Unreliable, error: &error)
        if error != nil {
            print("Error sending data: \(error?.localizedDescription)")
        }

        
    }
    @IBAction func swipeThreeDown(sender: UISwipeGestureRecognizer) {
        let message="swipeThreeDown"
        //we encode the string into NSData
        let msg=message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        var error : NSError?
        //we send the data to every peer that is connected to us in the session
        self.session.sendData(msg, toPeers: self.session.connectedPeers,
            withMode: MCSessionSendDataMode.Unreliable, error: &error)
        if error != nil {
            print("Error sending data: \(error?.localizedDescription)")
        }

    }
    @IBAction func handleScroll(sender: UIPanGestureRecognizer) {
        var translation: CGPoint!
        var velocity: CGPoint!
        translation = sender.translationInView(self.view)
        if(!(sender.velocityInView(self.view).x==0)&&(!(sender.velocityInView(self.view).y==0)))
        {
            velocity=sender.velocityInView(self.view)
        }
       if(sender.state==UIGestureRecognizerState.Cancelled){
            let message="scroll "+"\(velocity.y)"+" "+"cancel"
            velocity.x=0
            velocity.y=0
            //we encode the string into NSData
            let msg=message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            //we send the data to every peer that is connected to us in the session
            var error : NSError?
            self.session.sendData(msg, toPeers: self.session.connectedPeers,
                withMode: MCSessionSendDataMode.Unreliable, error: &error)
            if error != nil {
                print("Error sending data: \(error?.localizedDescription)")
            }
        }
       else if(sender.state==UIGestureRecognizerState.Began){
        let message="scroll "+"\(translation.y)"+" "+"begin"
        //we encode the string into NSData
        let msg=message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        //we send the data to every peer that is connected to us in the session
        var error : NSError?
        self.session.sendData(msg, toPeers: self.session.connectedPeers,
            withMode: MCSessionSendDataMode.Unreliable, error: &error)
        if error != nil {
            print("Error sending data: \(error?.localizedDescription)")
        }
       }

        else{
        
        let message="scroll "+"\(translation.y)"
        //we encode the string into NSData
        let msg=message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        //we send the data to every peer that is connected to us in the session
        var error : NSError?
        self.session.sendData(msg, toPeers: self.session.connectedPeers,
            withMode: MCSessionSendDataMode.Unreliable, error: &error)
        if error != nil {
            print("Error sending data: \(error?.localizedDescription)")
        }
        
        }

        
    }
    //this handle the touch input by using UIPanGestureRecognizer
    @IBAction func handleMove(sender:UIPanGestureRecognizer) {
        var translation: CGPoint!

        
        //translation gets the relative position in time during draging
        translation = sender.translationInView(self.view)
        //we send the data with tag brabeeba at each time when the touch begins
        if(sender.state==UIGestureRecognizerState.Began){
            let message="move "+"\(translation.x)"+" "+"\(translation.y)"+" "+"brabeeba"
            //we encode the string into NSData
            let msg=message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            //we send the data to every peer that is connected to us in the session
            var error : NSError?
            self.session.sendData(msg, toPeers: self.session.connectedPeers,
                withMode: MCSessionSendDataMode.Unreliable, error: &error)
            if error != nil {
                print("Error sending data: \(error?.localizedDescription)")
            }
        }
            //if it is in the middle of dragging, we don't add brabeeba tag
        else{
            let message="move "+"\(translation.x)"+" "+"\(translation.y)"
            //send information to peer
            let msg=message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            var error : NSError?
            self.session.sendData(msg, toPeers: self.session.connectedPeers,
                withMode: MCSessionSendDataMode.Unreliable, error: &error)
            if error != nil {
                print("Error sending data: \(error?.localizedDescription)")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showBrowser(sender: UIButton) {
        // Show the browser viewcontroller
        self.presentViewController(self.browser, animated: true, completion: nil)
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        // Called when the browser view controller is dismissed
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        // Called when the browser view controller is cancelled
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //those functions below are required by the protocal.
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
    }
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
    }
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
    }
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
    }
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
    }
}

