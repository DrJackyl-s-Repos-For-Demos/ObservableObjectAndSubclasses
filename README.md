# ObservableObjectAndSubclasses

ObservableObject does not work as expected with subclasses

"Subclasses of classes implementing `ObservableObject` don't work."

This never made sense to me. Inheritance still makes sense here and there and this should just work. As I now came across a case, where I could need inheritance and I realized I only had third-hand-information at most, I started investigating myself.

Clicking on either button increases count reflected in the trailing number. This _should_ be reflected when clicking both buttons.

When clicking 'Base', the UI updates as expected.

When clicking 'Sub', the UI does *not* updae as expected, until the `objectWillChange`-publisher is accessed in the sub-class.

When clicking 'Base', after clicking 'Sub', the UI reflects the changed counter of 'Sub' as well.

When running it in a simulator, the log-output shows, that it's not due to the redering of the UI not being triggered, but the publisher not emitting.

When doing the same in an Xcode Playground, the publisher does emit as expected.

I read about the "trick" with accessing the publisher in the sub-class here: https://forums.swift.org/t/subclass-of-an-observableobject-doesnt-cause-a-render-pass-in-swiftui-when-changing-published-properties-defined-in-the-subclass/41866
