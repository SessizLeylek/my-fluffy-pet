# my-fluffy-pet.exe

Made for [Ruin The Jam](https://itch.io/jam/ruin-the-jam) using [Odin](https://odin-lang.org/) and [Raylib](https://www.raylib.com/).
My initial intention was to really make a desktop pet, but then eventually it would turned out to be a trojan(\*ahem\*BonziBuddy\*ahem\*) as a joke. But i was too unserious about it and it quickly became an absurd shit-show.
[You can download and play the game from itch.io](https://sessizleylek.itch.io/my-fluffy-pet).

I know the scripting in the code is very poor but i was not sure how this was gonna turn out so didn't deal with a proper refactor.
If you are looking at this repo to get inspired, i would suggest ignoring the code in this repo and trying something like this below:
```
EventId : distinct int

ScriptEvent : struct {
    on_update: proc(),
    on_complete: proc(), 
    condition: proc() -> bool,  // You can also make this an array to have 
    next_event_id: EventId,     // multiple end conditions and routes
}

EventTimeline : struct {
    events: []ScriptEvent,
    current_event_id: EventId,
}
timeline : EventTimeline

update_timeline :: proc() {
    event := timeline.events[timeline.current_event_id]

    event.on_update()

    // If you decided to have multiple end conditions,
    // check them all in a loop and break after first condition met
    if event.condition() {  
        event.on_complete()
        timeline.current_event_id = event.next_event_id
    }
}
```
