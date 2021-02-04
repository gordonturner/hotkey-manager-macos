# Readme

This is an app to send keypresses to applications.  

The short term goal, as a proof of concept, is to send a command + r sequence to a Chrome browser window to perform a refresh.  

**NOTE:** You will need to grant the app permissions in Security + Privacy, Accessibility.

**NOTE:** You will need to look up the Google Chrome process id for your local running app.  

To look up the tab process, in Chrome click on the three dots (top right), `More Tools`, `Task Manager`.


## Unanswered Questions

- Why won't this work?  Duh.
- Do you need to send the key presses to the parent pid or children of the browser (each browser tab has it's own process)?


## Test Send Command-R to Browser

- To test hotkey, use the browser refresh, command-r, to confirm approach


## Events in MacoS

/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Headers/Events.h

https://gist.github.com/eegrok/949034

- "R" is `0x0F` or `kVK_ANSI_R`


## Approach 1

- Search for `swift send keystroke to process`
- Lots of hits for iOS

- MacOS has CGEventSource:
https://developer.apple.com/documentation/coregraphics/cgeventsource

- Seems to be the appropriate way to send events
- Need to determine how to correctly target the process


## Solution 1

https://stackoverflow.com/questions/54337561/send-keypress-to-specific-window-on-mac

```
import Foundation

let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
    
let kspd = CGEvent(keyboardEventSource: src, virtualKey: 0x31, keyDown: true)   // space-down
let kspu = CGEvent(keyboardEventSource: src, virtualKey: 0x31, keyDown: false)  // space-up

let pids = [ 24834, 24894, 24915 ]; // real PID-s from command 'ps -ax' - e.g. for example 3 different processes
    
for i in 0 ..< pids.count {
    print("sending to pid: ", pids[i]);
    kspd?.postToPid( pid_t(pids[i]) ); // convert int to pid_t
    kspu?.postToPid( pid_t(pids[i]) );
}
```

- Might work, but need to include command key


## Approach 2

- Using CGEventSource, how to send command key?

- Search for `macos swift cgeventsource command keystroke`

- Use `keyDownEvent?.flags = .maskCommand`
- According to:
https://stackoverflow.com/questions/27484330/simulate-keypress-using-swift

```
let source = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

let cmdKey: UInt16 = 0x38
let numberThreeKey: UInt16 = 0x14

let cmdDown = CGEvent(keyboardEventSource: source, virtualKey: cmdKey, keyDown: true)
let cmdUp = CGEvent(keyboardEventSource: source, virtualKey: cmdKey, keyDown: false)
let keyThreeDown = CGEvent(keyboardEventSource: source, virtualKey: numberThreeKey, keyDown: true)
let keyThreeUp = CGEvent(keyboardEventSource: source, virtualKey: numberThreeKey, keyDown: false)


fileprivate func testShortcut() {

let loc = CGEventTapLocation.cghidEventTap

cmdDown?.flags = CGEventFlags.maskCommand
cmdUp?.flags = CGEventFlags.maskCommand
keyThreeDown?.flags = CGEventFlags.maskCommand
keyThreeUp?.flags = CGEVentFlags.maskCommand

cmdDown?.post(tap: loc)
keyThreeDown?.post(tap: loc)
cmdUp?.post(tap: loc)
keyThreeUp?.post(tap: loc)

}
```



- Use `spcd?.flags = CGEventFlags.maskControl;`
- According to:
https://stackoverflow.com/questions/61820770/move-left-or-right-a-space-programmatically-osx

https://stackoverflow.com/questions/55839529/simulate-media-key-press-in-macos


https://stackoverflow.com/questions/11045814/emulate-media-key-press-on-mac









