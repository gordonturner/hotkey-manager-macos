import Foundation

// Define Source
let source = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

// Define the virtualKey
let cmdKey: UInt16 = 0x38
let letterRKey: UInt16 = 0x14

// Define the key events
let rDown = CGEvent(keyboardEventSource: source, virtualKey: letterRKey, keyDown: true)
let rUp = CGEvent(keyboardEventSource: source, virtualKey: letterRKey, keyDown: false)

// Apply the command mask to all keys, maybe not needed for rUp?
rDown?.flags = CGEventFlags.maskCommand
rUp?.flags = CGEventFlags.maskCommand

// List of process ids
let pids = [ 1847, 8645 ];
    
for i in 0 ..< pids.count {
    
    print("Sending to pid: ", pids[i])
    
    rDown?.postToPid( pid_t(pids[i]) )
    rUp?.postToPid( pid_t(pids[i]) )
}
