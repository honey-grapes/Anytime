# Anytime 通話易
![Anytime Banner](https://user-images.githubusercontent.com/66938562/205561797-3e0e99aa-27d6-407c-b585-dda6e54fa8f7.png)

## Table of Contents
* [About](#about)
  *  [Rationale](#rationale)
  *  [Prerequisites and Setup](#prerequisites)
* [Features](#features)
  *  [Login and Navigation](#login-and-navigation)
  *  [Add New Contact](#add-new-contact)
  *  [Call Contacts](#call-contacts)
  *  [Browse Feed and Add Posts](#browse-feed-and-add-posts)
  *  [Add New Contact](#dark-mode-and-logout)
* [Future Implementations](#future-implementations)
* [Resources](#resources)

## About
Anytime (通話易) is a Mandarin iOS communication app that aims to improve the accessibility of online communication for seniors built with Swift, SwiftUI, and Firebase. The app is called Anytime because it allows seniors to stay in touch with their loved ones anytime without assistance.

### Rationale
My rationale of creating this app is to facilitate online communication between my family members, especially with my grandma. I mostly communicate with my family through WeChat and WhatsApp. My grandma has a WeChat account but she is deterred from using to apps like WeChat and the iOS Phone app for several reasons.

1. **Too many features**: One of the key detergents is that both of these communication apps have too many features that she does not use. To younger users, more features may be an appeal, but they may serve as obstacles to senior users. She found it overwhelming to look for the features she wants to use among the myriads of additional features. Since typing is not an option for her, the only features that are useful to her are calling and browsing her feed. 

2. **Navigation not intuitive**: Similarly, she also told me she believes switching through different tabs and sheets is a hassle because she often forgets how to navigate back to the page where she was. On WeChat, you would have to navigate through at least 3 views to add a contact and 2 views to browse the feed. There are a lot of features that she does not use. She finds it frustrating to accidentally click into one and unable to navigate back to where she was.  

3. **Hurdles in adding new contacts**: Typing isn't as intuitive for seniors especially when it comes to typing in Mandarin (It is a logogram unlike most phonogramic languages in the world. There are a lot of characters that sound the same but are vastly different in meaning and written form). Even Gen Xs like my parents prefer iOS's handwriting recognition and voice control for messaging. Due to this, my grandma needs assistance everytime she adds a new contact. Moreover, the new contact buttons are often hidden in the corner and the page/sheet itself has many extraneous options such as ring tone, url, QR Code, and social media profile. To seniors, this makes the new contact feature confusing when all they want is to add the new contact's name and phone number for future use. 

After searching the App Store, I cannot find a simple and accessible Mandarin communication app that suits her needs. Therefore I decided to develop an app myself and, in the future, deploy it privately through Firebase to my family members.

### Prerequisites
<p align="left">
 <!--Swift-->
<img height="30" width:"30" src="https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white" />
<!--Firebase-->
<img height="30" width:"30" src="https://img.shields.io/badge/firebase-ffca28?style=for-the-badge&logo=firebase&logoColor=black" />
</p>

- Swift 5.6.1
- Targeting platform version iOS 16+
- Built with Xcode 14+ (macOS Monterey 12.3+ required)

**From FirebaseAuth, FirebaseFirestore, and FirebaseStorage from the Firebase SDK package on Xcode**
- Firebase 9.6.0
- GoogleAppMeasurement 9.6.0
- GoogleDataTransport 9.2.0
- abseil 0.20220203.2
- gRPC 1.44.3-grpc
- BoringSSL-GRPC 0.9.1
- GTMSessionFetcher 2.1.0
- leveldb 1.22.2
- nanopb 2.30909.0
- Promises 2.1.1
- SwiftProtobuf 1.20.2

### Setup
- To clone this project for your own use, it might be a good idea to delete the <code>GoogleService-Info.plist</code> and [set up your own Firebase project](https://firebase.google.com/docs/ios/setup). 
- Xcode 13.3.1+ is required to build an iOS Firebase project and Firebase is only compatible with iOS 11+. However, since this project utilizes the new <code>DataScannerViewController</code> API (Live Text API) launched in June 2022, its target platform is iOS 16+. 

## Features
There are four key features: 1) Authentication, 2) Add new contact, 3) Browsing contact, and 4) Interactive feed

### Login and Navigation
Users can register with their phone numbers (considering seniors might not have emails or social media accounts). After registering and getting verified, they can start using the app. The app consists of three different views which are accessible through swiping and clicking on the customized navbar with big icons and font. From left to right on the navbar are Contacts, Add Contact, and Feed. A new user would have no contacts and no feed displayed. 

The header shows the title of the page and Settings on the top righthand corner. This is where I put all the features that are deprioritized because they won't be accessed often. Currently there are three buttons, Dark Mode, Go Back, and Logout. 

<p align="center"><img src="https://media.giphy.com/media/I5GN4JLZVTvmX5uQjw/giphy.gif"></p><br>


### Add New Contact
Instead of having the Add New Contact button tucked away in the corner, it is available in the navbar for easy access. I have also laid out all the step-by-step instructions in readable font on how to add a contact. There is minimal need to switch to other views or modals in the process. Unnecessary input fields like url, address, QR code, social media...etc. are also eliminated. Since call is the core feature, the app only store the contact's name, number, and photo into Firebase.

I have decided to use the new <code>DataScannerViewController</code> API for inputting contact information because inputing contact information with voice is inefficient. A lot of characters sound the same in Mandarin and you would have to manually choose each character after voice recognition (see Note for more). In terms of handwriting recognition, I would like to conduct some user testing first to determine whether it is easy enough to use for my grandma.

Writing down contact information on a piece of paper just like a traditional phonebook seems more intuitive than the two options above. I have provided the instructions on how to use the scanner and also a preview and option to re-scan. There are also two options to upload the profile photo. Whenever the user is navigated to another view or modal, it is made clear how to navigate back to the Add New Contact view.
<br>

<p align="center"><img src="https://media.giphy.com/media/t0SWfp0bzwE98IfgXb/giphy.gif"></p>

**Note**: Voice recognition in Mandarin is much more effective in messaging because characters prioritized based on maximum likelihood estimation given a sentence or context. On the other hand, the characters in a name can be completely meaningless, contextless, and irrelevant to other characters in the name. It is also not unusual for people to use rare or obsolete characters in their names (only ~3,000 characters out of 50,000+ characters are used on a regular basis). In fact most people do not know how to pronounce the third character in my name because it's obsolete. In voice recognition, this character would likely be the 10th-15th option given characters with the same pronunciation.

### Call Contacts
Instead of the usual list view in most communication iOS apps, I have implemented an interface where users can simply click on the pictures to make calls. 

<p align="center"><img src="https://media.giphy.com/media/cLMiuLLDYtzTD9SNRZ/giphy.gif"></p>


### Browse Feed and Add Posts
<p align="center"><img src="https://media.giphy.com/media/rMc4QvPaj58Et1MByJ/giphy.gif"></p>


### Dark Mode and Logout
<p align="center"><img src="https://media.giphy.com/media/GLe028a7Eu5PWqiGjB/giphy.gif"></p>


## Future Implementations
- Contacts 
  - Move Contact into ContactViewModel
- Add Contact
  - Disable further steps in the Add Contact view unless previous steps are completed
  - Potentially provide the option to input contact information with handwriting
- Feed 
  - Move Feed into FeedViewModel
  - Implement limit and possibly drag to refresh functionalities
  - Better implementation for feed: I am considering modifying the feed so that you can only see a contact's feed after they've added you as well. Regarding likes given by contacts that have been deleted (therefore are no longer authorized to see your feed), maybe I could think of a way to delete their likes as well after they've been deleted.
- Deployment: Currently I have completed the app in the development environment and have built and tested it on my phone. After more testing and tweaks, I plan to deploy and distribute the app through Firebase App Distribution and register my family members as testers. 

## Resources
In addition to the Swift and Firebase Documentations, I found the following tutorials to be helpful in developing the app:
 - [Cloud Firestore Get Data (and other operations) with SwiftUI](https://www.youtube.com/watch?v=xkxGoNfpLXs&t=134s&ab_channel=CodeWithChris) by CodeWithChris
 - [Uploading Images to Firebase Storage (and retrieving them)](https://www.youtube.com/watch?v=YgjYVbg1oiA&ab_channel=CodeWithChris) by CodeWithChris
 - [SwiftUI 2.0 Login Page With Firebase Phone Auth - Part 2: Firebase Integration](https://www.youtube.com/watch?v=P4avA9K9r1U&t=528s&ab_channel=Kavsoft) by Kavsoft
