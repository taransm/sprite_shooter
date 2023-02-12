# sprite_shooter
## Description:
I have built a challenge-based Augmented Reality shooting game using ARKit and written in Swift. I added 2D/3D elements to the live view from the device’s camera, making those elements appear to inhabit the real world. The gameplay is simple, just look around you and shoot every enemy under the lowest time possible!

The score, which is the time it took to complete the task is stored using <strong> Firebase </strong>. This allows users to compete against their own time. With this app you can convert any environment like park, library, restaurant (the limit is your imagination!) into a real world game.
## Design & Implementation: 
I used ARKit to combine device motion tracking, camera scene capture, advanced scene processing, and display conveniences, simplifying the task of building an AR experience. To enhance the gaming experience, I added sound effects and background music using AVPlayer. The app also contains multiple classes for various functionalities, including ARSKView, ARSession, ARFrame, ARAnchor, and SpriteKit (SKScene, SKSpriteNode, SKAction, SKNode). I utilized Cocoapods for managing external libraries.


:bulb:IMP: Make sure that .plist files are updated, I have deleted the content for security reasons

:bulb:IMP: How to setup firebase: https://firebase.google.com/docs/ios/setup 
![IMG_1061](https://user-images.githubusercontent.com/67748452/218292679-b4b40245-e115-4a3f-8d10-afce4bc813ea.PNG)
![IMG_1062](https://user-images.githubusercontent.com/67748452/218292681-1611350d-8fe1-4ac0-81cd-1f77bbcc7186.PNG)
![IMG_1063](https://user-images.githubusercontent.com/67748452/218292683-83e7128b-8274-423c-b474-c50d0e5c9d14.PNG)
