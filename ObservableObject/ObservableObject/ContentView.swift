import SwiftUI
import Combine

struct ContentView: View {
    private let readMe = """
"Subclasses of classes implementing `ObservableObject` don't work."

This never made sense to me. Inheritance still makes sense here and there and this should just work. As I now came across a case, where I could need inheritance and I realized I only had third-hand-information at most, I started investigating myself.

Clicking on either button increases count reflected in the trailing number. This _should_ be reflected when clicking both buttons.

When clicking 'Base', the UI updates as expected.

When clicking 'Sub', the UI does *not* updae as expected, until the `objectWillChange`-publisher is accessed in the sub-class.

When clicking 'Base', after clicking 'Sub', the UI reflects the changed counter of 'Sub' as well.

When running it in a simulator, the log-output shows, that it's not due to the redering of the UI not being triggered, but the publisher not emitting.

When doing the same in an Xcode Playground, the publisher does emit as expected.

I read about the "trick" with accessing the publisher in the sub-class here:
"""
    
    private let link = "https://forums.swift.org/t/subclass-of-an-observableobject-doesnt-cause-a-render-pass-in-swiftui-when-changing-published-properties-defined-in-the-subclass/41866"
    
    @ObservedObject var model = Models.sub
    
    var body: some View {
        VStack(spacing: 32) {
            Button(
                action: {
                    model.aBaseProperty += 1
                    Models.log.log()
                },
                label: {
                    Text("Base: \(model.aBaseProperty)")
                }
            )
            
            Button(
                action: {
                    model.aSubProperty += 1
                    Models.log.log()
                },
                label: {
                    Text("Sub: \(model.aSubProperty)")
                }
            )
            
            Text(readMe)
                .font(.caption)
            
            Button(
                action: {
                    UIApplication.shared.open(URL(string: link)!)
                },
                label: {
                    Text(link)
                }
            )
        }
        .onAppear {
            Models.log.log()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class Base: ObservableObject {
    @Published var aBaseProperty: Int = 0
}

class Sub: Base, CustomStringConvertible {
    override init() {
        super.init()
        
        // Uncomment to make it work
//        _ = objectWillChange
    }
    
    @Published var aSubProperty: Int = 0
    
    var description: String {
        "Sub(aBaseProperty=\(aBaseProperty), aSubProperty=\(aSubProperty))"
    }
}

class Log {
    init(model: Sub) {
        self.model = model
        
        model.objectWillChange
            .sink(receiveValue: {
                print("Model will change. Current: \(model)")
            })
            .store(in: &subscriptions)
    }
    
    let model: Sub
    var subscriptions: Set<AnyCancellable> = []
    
    func log() {
        print(model)
    }
}

class Models {
    static let base = Base()
    static let sub = Sub()
    static let log = Log(model: sub)
}
