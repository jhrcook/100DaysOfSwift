# 100 Days of Swift - "Names to Faces" iOS App

![100DaysOfCodeSwift](https://img.shields.io/badge/100DaysOfCode-Swift-FA7343.svg?style=flat&logo=swift)
[![jhc github](https://img.shields.io/badge/GitHub-jhrcook-lightgrey.svg?style=flat&logo=github)](https://github.com/jhrcook)
[![jhc twitter](https://img.shields.io/badge/Twitter-@JoshDoesA-00aced.svg?style=flat&logo=twitter)](https://twitter.com/JoshDoesa)
[![jhc website](https://img.shields.io/badge/Website-Joshua_Cook-5087B2.svg?style=flat&logo=telegram)](https://joshuacook.netlify.com)

**Start Date: June 5, 2019  
End Date: September 13, 2019**

I want to learn how to program in the Swift language. To this end, I will practice coding in Swift for at least one hour every day for 100 days.

This is an example iOS project produced by [*Hacking with Swift*](https://www.hackingwithswift.com/read) called ["Names to Faces"](https://www.hackingwithswift.com/read/10/overview). This app will show images of people labeled with their names. I will post images below of the view of the app after each day's work.

## Daily progress of "Names to Faces" app

**Day 1 - July 4, 2019**

I have set up the basics of the IB, but not far enough to build.

**Day 2 - July 5, 2019**

I finished the "Names to Faces" app. It allows the user to load photos from the photo library or take a new photo with the camera. The label can then be changed or the image deleted by tapping on the photo. The camera functionality is not shown here because it isn't available on the simulator, though I tested it on my iPhone. If the camera is available, then an alert controller pops up when the "+" button is tapped asking the user if they want to take a new photo or load from the photo library.

<img src="progress_screenshots/Jul-05-2019 09-31-13.gif" width="300"/>

**Day 3 - July 8, 2019**

I added data persistence using `Codable` (project 10a used `NSCoding`). The app now also properly deletes the actual image files when the image is removed from the `people` array.

<img src="progress_screenshots/Jul-08-2019 08-19-31.gif" width="300"/>
