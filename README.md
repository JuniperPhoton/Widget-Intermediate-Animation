# Widget Intermediate Animation Demo
A demo to demonstrate how to animate widget changes with intermediate state.

## Required

This demo is based on the SwiftData demo in Xcode 15. Currently you need Xcode 15 Beta to open this project and runs on the devices or simulators in iOS 17.

## Demo time

<img src="https://github.com/JuniperPhoton/WidgetIntermediateAnimation/assets/7578386/32c269ea-339e-49a7-88ac-fe352147b05c" width="300"/>

1. Build and install the app
2. Add a widget in the home screen
3. Launch the app, add some reminders
4. Go back to the home screen and now you can see the reminders you previously added
5. Click the circle to the left which will mark a reminder "complete"
6. Now you can see the circle is filled with a check icon and then disappear with fine animation

## Implementation details

The keys to achieve this effect are:
1. When the button with `AppIntent` is clicked the `AppIntent`'s perform method will be invoked
2. After you successfully perform the action, the timeline need to be reconstructed
3. The timeline should at least contains two entries: one for displaying the "recently completed" items(in this case, the reminder that its completed date is less than 2 seconds to now); and one for displaying the incompleted items.
4. In iOS 17, the animation is added by the system to animate between two entries in a timeline.
