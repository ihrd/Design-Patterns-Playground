// TODO: # Motivation

//: Real-world analogy is a newspaper subscription. This pattern is usually
//: a part of MVC. View broadcasts UI events so that Controller can handle
//: them appropriately.
//: ### Definition
//: The Observer pattern defines a one-to-many dependency between objects
//: so that if one object changes state, all of it's dependent objects are notified and
//: can be updated automatically.

//: ### Weather station example (basic design)

protocol Observable {
    // TODO: It should be weak is not it?
    // But I can't do so here... hm...
    var  observers: [Observer] { get set }
    func addObserver (observer: Observer)
    func removeObserver (observer: Observer)
    func notifyObservers ()
}

// This "class" means that this protocol is only for classes and we need
// that to be able to check identity of Observers in removeObserver
protocol Observer : class {
    // FIXIT: in beta5, serviceKit terminated on desired declaration
    // func update (updatedObject: Observable)
    func update (updatedObject: AnyObject)
}

// This enum and struct completely unnecessary, added for convinience
enum MesureType {
    case Humidity, Temperature, Pressure
}

struct Mesures {
    var data = [MesureType : Double]()
}

class WetherStation : Observable {
   
    var mesures: Mesures = Mesures() {
        didSet {
            print("\n### Updtae form Station ###\n")
            self.notifyObservers()
        }
    }
    
    var observers = [Observer]()

    func addObserver(observer: Observer) {
        observers.append(observer)
    }
    
    func removeObserver(observer: Observer) {
        observers = observers.filter{ $0 !== observer }
    }
    
    func notifyObservers() {
        for observer in observers {
            observer.update(self)
        }
    }
}

protocol Display {
    func display ()
}

class CurrentConditionDisplay : Observer, Display {
    var temperature: Double?
    
    func update (updatedObject: AnyObject) {
        if let wetherStation = updatedObject as? WetherStation {
            self.temperature = wetherStation.mesures.data[.Temperature] ?? nil
        }
        
        display()
    }
    
    func display() {
        print("--- Current ---")
        if let temp = self.temperature {
            print("Temeperature is \(temp)˚C")
        } else {
            print("We have no idea what is goinig on outside.")
        }
    }
    
    // TODO: Hmmm... I beilive I need a way to remove
    // self from observers in deinit.
    deinit { }
}


class AwesomeDisplay : Observer, Display {
    func update (updatedObject: AnyObject) {
        display()
    }
    
    func display() {
        print("--- Awersomeness ---")
        // Sorry, just random stuff
        print("Everything is awesome! Everything is cool if you live on the heap. Everything is awes-o-o-ome! While you l-i-i-i-nked.\n")
    }
}

import Foundation // for NSDate

class WetherStatisticDisplay : Observer, Display {
    var data = [NSTimeInterval : Mesures]()
    
    func update (updatedObject: AnyObject) {
        if let wetherStation = updatedObject as? WetherStation {
            let timeStamp = NSDate().timeIntervalSinceReferenceDate
            data[timeStamp] = wetherStation.mesures
        }
        
        display()
    }
    
    func avarageTemperature () -> Double {
        
        var numberOfMesures = 0
        var sum = 0.0
        
        for (_, value) in data {
            if let temp = value.data[.Temperature] {
                sum += temp
                numberOfMesures++
            }
        }
        return sum / Double(numberOfMesures)
    }
    
    func display() {
        print("--- Staticstics ---")
        switch data.count {
            case 0:
                print("Have no data to analyze.\n")
            case 0..<3:
                print("Need more measures.\n")
            default:
                print("Avarage temperature is \(avarageTemperature())\n")
        }
    }
}

let wetherStation = WetherStation()
let current = CurrentConditionDisplay()
let stat = WetherStatisticDisplay()
let awesome = AwesomeDisplay()

current.display()
stat.display()

wetherStation.addObserver(current)
wetherStation.addObserver(stat)
wetherStation.addObserver(awesome)

wetherStation.mesures = Mesures(data: [.Humidity: 42.05, .Temperature: 34.4 , .Pressure: 1001 ])

wetherStation.removeObserver(awesome)

wetherStation.mesures = Mesures(data: [.Humidity: 52.8, .Temperature: 36.7 , .Pressure: 998 ])

wetherStation.mesures = Mesures(data: [.Humidity: 80.1, .Temperature: 32.1 , .Pressure: 1009 ])

// Yes, actualy it is so hot in Hopng Kong :/
wetherStation.mesures = Mesures(data: [.Humidity: 60, .Temperature: 37, .Pressure: 1001 ])

// TODO: I saw a lot of posts about observers on devforum, need to check 
// and add native version of it in separate playground
