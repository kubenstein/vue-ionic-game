# Vue + Ionic Game

During this hackathon I was exploring Ionic framework.

The long term goal is to be able to leverage all my JS web app skills to deliver native apps fast.

# Demo:
![demo](./.readmeAssets/gamePlay.gif)

(The game runs smoothly on 30fps, low framerate is just to optimise the gif)


## General Architecture
The app is split into 2 parts, iOS project and the vue-based website running the game.

### The iOS project

A full iOS project with all its files. We basically don't touch those files as everything is handled by the Capacitor (scroll down for more info).

All native mobile features used by the game, such as vibrations, orientation lock or local storage are done by adding corresponding npm integration packages and running: `npx cap update`.

The only few things I had to manually change were: adding an appIcon and configuring ProvisioningProfiles.

### The Vue-based Game
The Game is a normal vue webapp with two screens. Most of game objects are absolutly positioned html elements. The Game loop runs at 30fps smoothly on my iPhone XS.

The game itself is a very basic state machine implemented using vue `watch` section.

Collision detection is implemented based on detecting rectangular intersection between coordinates of the player and obstacles. Since the player actually never moves on X axis, we can easily filter out all obstacles that are for sure too far from the player to colide.

Falling is implemented by having a constant gravity force, then calculating Y velocity, and then updating Y position of the player. Jumping means just resetting Y velocity to a fixed value that will be gradually altered by gravity force later on. Values of gravity force and jumping velocity were manually calibrated.


### [Ionic](https://ionicframework.com/) vs [Capacitor](https://capacitorjs.com/)
This project uses only Capacitor which is the core gluing technology used by Ionic. Ionic is a UI framework providing native look and feel of elements. Its built on top of Capacitor. I wanted to focus on Capacitor only as I wanted to build whole UI by myself.

Capacitor is a very slim and pleasurable to work with layer, while Ionic is a massive UI framework you have to learn and build whole app using nearly exclusively only it.

## Development
Development environment is configured to run as a web app in a browser. Occasionally I build and run the app on the real device/simulator to check if there are any differences.

```bash
nvm use
yarn
yarn run dev
```

## Building the app
[The build script I wrote](./scripts/build.sh) can built the app in two modes:

- Involving xcode - this mode is a semi-automated mode. The web app and the iOS app are prepared with all dependencies. Then the xcode project is created and opened. From now on you can manually choose what device you want to deploy to and press the Xcode build button.
```bash
yarn run build:open-xcode
```

- Not involving xcode - this mode provides fully automated builds and deployment to connected device. It uses `xcrun xcodebuild` tool to build iOS project and [`ios-deploy`](https://github.com/ios-control/ios-deploy) to deploy it to a connected iPhone. All from the command line!
```bash
yarn run build:run-on-connected-device
```
