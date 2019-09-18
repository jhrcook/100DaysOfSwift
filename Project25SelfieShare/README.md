# 100 Days of Swift - "Selfie Share" iOS App

![100DaysOfCodeSwift](https://img.shields.io/badge/100DaysOfCode-Swift-FA7343.svg?style=flat&logo=swift)
[![jhc github](https://img.shields.io/badge/GitHub-jhrcook-lightgrey.svg?style=flat&logo=github)](https://github.com/jhrcook)
[![jhc twitter](https://img.shields.io/badge/Twitter-@JoshDoesA-00aced.svg?style=flat&logo=twitter)](https://twitter.com/JoshDoesa)
[![jhc website](https://img.shields.io/badge/Website-Joshua_Cook-5087B2.svg?style=flat&logo=telegram)](https://joshuacook.netlify.com)

**Start Date: June 5, 2019  
End Date: September 13, 2019**

I want to learn how to program in the Swift language. To this end, I will practice coding in Swift for at least one hour every day for 100 days.

This is an example iOS project produced by [*Hacking with Swift*](https://www.hackingwithswift.com/read) called ["Selfie Share"](https://www.hackingwithswift.com/read/25/overview). This app is designed to teach me about using `MultipeerConnectivity`, a library for quickly sharing data between multiple devices. I will post images below of the view of the app after each day's work.

## Daily progress of "Selfie Share" app

**Day 1 - July 25, 2019**

I created an app that loads images from the Photos library and shares them to all connected devices. In the example, I create a network between the iOS Simulator and my iPhone 6S, using the iPhone as the host. I then load an image from the library, and it instantly appears on the simulator. The same can be done in other direction, too.

left: iPhone 6S - right: simulator (iPhone XR)

<img src="progress_screenshots/ezgif.com-video-to-gif_phone.gif" height="500"/>
<img src="progress_screenshots/Jul-25-2019 08-05-09_simulator.gif" height="500"/>'

**Day 2 - July 27, 2019**

I finished two of the three challenges for the Selfie Share app (the third was much more invovled than I really desired). The first challenge was to display an alert when someone disconnects: this was implemented in the switch-case statement in `session(:peer:didChange)`. The second challenge was to add a button to display all phones connected to the session: if there were multiple connected peers, an additional button was available in the `+` alert controller that would present another alert with effectively the following expression `[peerID.displayName].joined(", ")`.

<img src="progress_screenshots/Jul-27-2019 19-04-17.gif" height="500"/>
