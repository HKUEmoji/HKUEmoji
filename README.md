# HKUEmoji

The category of our application is entertainment. We design a photo processing application which can help users make their own static emoticons and dynamic emoticons, and they can share the emoji to other peoples.

Our development target is iOS 9.0.

# How to Build it
Use Xcode to open HKUEmoji.xcodeproj directly. Make sure the target you want to build is HKUEmoji on iPhone 6, then just run it.

## Motivation:
Our goal is to develop a photo processing application which can generate funny expression. Our application can provide the most popular functions for users and users can share their DIY emoticons on social network. The application can help users to record the most beautiful moment and heighten user’s confidence. 
## Functions and Design:
We designed four functions for our application:

1)	Take Photos and Face Identification

2)	Static Emoticon

Use GPUImage to turn a real picture into cartoon style. Like the following image.

3)	Dynamic Emoticon

We design the ‘dynamic emotion’ function to help users design their own dynamic emoticon. User can browse multiple dynamic templates in different style, and then choose one template to generate a unique dynamic emoticon. Our application can cut out user’s photo, extract his facial expression and then embed the facial expression on the elected template. Finally, the unique dynamic emoticon can be displayed on the screen.

This function was implemented using animation method. The UIImage can invoke animation method to divide dynamic emoticon into multiple frames and then read and display dynamic emoticon frame by frame.

4)	Photo Store and Share

In order to provide users good user experiences and encourage them to share the interesting emoticons generated with their friends, we implemented the share function for the resulted dynamic emoticon, static emoticon and local emoticon. Users can simply click a ‘share’ button to deliver the emoticons to different kinds of online social platforms such as weChat, sina weibo, qq, Facebook, Instagram, what’s app, renren and so on. We realized this function by integrating ShareSDK toolkit into the program to provide smooth, stable and efficient experiences.

##Creativity:

Our application has three creativities:

1)	Photo processing and Face identification:

We design the face identification function for our application. When the user takes photo or upload a photo from local album to the application, our application can invoke the face identification method and identify user’s face in the photo. Our application can identify people’s face well than other image processing applications. Firstly, it can identify the contour of objects in the photo, and then it can judge whether the object is a valid face. It can identify user’s face according to the facial features. Finally, it can generate the user’s face which can be used in the emoticon generation.

Since we can identify user’s facial features accurately, the generated emoticon can be more real and vivid. Our application can blur the boundary between user’s face and emoticon templates. It seems that the user’s face and emoticon templates are an entire unit.

2)	Popular function integration: 

We made a detailed background research before we develop the application, and then we selected some popular functions within different applications as our main functions. Users do not need to install many different applications to experience different functions, and users can experience the most popular functions using our application. Nowadays, functions of photo processing are divided into different kind of applications, and our creativity is integrating these functions and then provide the best experience for users. 

3)	UI design:

UI design is very important for mobile applications, especially for photo processing application, therefore, we design our application in flatten style which can absorb more users. And we also consider the persistence of our application. We will develop new functions continuously in the future.

# Team member and Contribution

Wang Youan(Student ID: 3035237236): Merge Code, Turn picture from real into cartoon style, Generate Static Expression, handle page jump

Hou Chengcheng(Student ID: 3035237107): Generate Dynamic Expression, Design UI, Design Icon, Writing Summary Part.

Hu Hao(Student ID:3035237389 ): Call system camera and album, face pick function, store emojis to app’s own album, show local emojis. 

Li Wei(Student ID: 3035237212): Share picture to social platforms, Design home page, background research
