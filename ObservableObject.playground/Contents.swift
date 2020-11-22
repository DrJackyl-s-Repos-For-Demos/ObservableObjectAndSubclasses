import Combine

class Base: ObservableObject {
    @Published var aBaseProperty: Int = 0
}

class Sub: Base, CustomStringConvertible {
    override init() {
        super.init()
        
        // Here it works without this!
        // Uncomment to make it work
//        objectWillChange
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

Models.log.log()
Models.sub.aBaseProperty += 1
Models.log.log()
Models.sub.aSubProperty += 1
Models.log.log()
