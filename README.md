# Vue + Ionic Game

During this hackathon I was exploring Ionic framework.

The long term goal is to be able to leverage all my JS web app skills to deliver native apps fast.

# Demo:
![demo](./.readmeAssets/gamePlay.gif)

(The game runs smoothly on 30fps, low framerate is just to optimise the gif)


## General Architecture
The app is split into 2 parts, iOS project and the vue-based website running the game.

### The iOS project

A full iOS project with all its files. We basically don't touch those files as everything is handled by Capacitor (scroll down for more info).

All native integrations used by the game, such as vibrations, orientation lock or local storage are done by adding npm integration package and running: `npx cap update`.

The only things I had to manually changed were adding appIcon and configuring ProvisioningProfiles to be able to run app on my iPhone.

### The Vue-based Game
The Game is a normal vue web app with two screens. Most of game objects are absolute positioned html elements. The Game loop runs at 30fps smoothly on my iPhone XS.

The game is a very basic state machine implemented using just vue `watch` section.

Collision detection is implemented based on detecting rectangular intersection between player and obstacles coordinates. Since the player actually never move in X direction, we can easily filter out all obstacles that are for sure too far from the player to colide.

Falling is implemented by having a constant gravity force, then calculating Y velocity and then updating Y position of the player. Jumping means just resetting Y velocity to a fixed value that will be gradually altered by gravity force. Values of gravity force and jumping up velocity were manually calibrated.


### [Ionic](https://ionicframework.com/) vs [Capacitor](https://capacitorjs.com/)
This project uses only Capacitor which is the core gluing technology. Ionic is build on top of Capacitor and is a UI framework providing native look and feel of elements. I wanted to focus on Capacitor as I wanted to build UI myself.

Capacitor is a very slim and pleasurable to work with layer, while Ionic is a massive UI framework you have to learn and build whole the app using only it.

## Development
Development environment is configured to run as a web app in browser. Occasionally I build and run the app on the real device/simulator.

```bash
nvm use
yarn
yarn run dev
```

## Building the app
[The build script I wrote](./scripts/build.sh) can built the app in two modes:

- Involving xcode - this mode is a semi automated mode. The web app and the iOS app is prepared with all dependencies and the xcode project is created and the xcode is opened. Now you can manually choose what device you want to deploy to, real or simulator and press build button.
```bash
yarn run build:open-xcode
```

- Not involving xcode - this mode is fully automated. It uses using `xcrun xcodebuild` tool to build iOS project and [`ios-deploy`](https://github.com/ios-control/ios-deploy) to deploy it to connected iPhone. All from command line!
```bash
yarn run build:run-on-connected-device
```
