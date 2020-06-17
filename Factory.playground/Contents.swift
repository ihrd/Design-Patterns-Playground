
//TODO: # Motivation

//: ### Definition
//: The Factory Method Pattern defines an interface for creating an object,
//: but lets subclasses decide which class to instantiate. Factory Method
//: lets a class defer instantiation to subclasses.
//: ### Simple pizza factory example

class Pizza {
    var name = String()
    
    enum Dough: String { case Thin = "thin", Thick = "thick" }
    var dough = Dough.Thin
    
    var souce = String()
    var toppings = [String]()
    
    func prepare() {
        print("Preparing \(name)")
    }
    
    func bake() {
        print("Bake \(name): \(toppings) on \(dough.rawValue) dough")
    }
    
    func cut() {
        print("Cutting \(name)")
    }
    
    func box() {
        print("Boxing \(name)")
    }
}

class PeperoniPizza : Pizza {
    override var name: String {
        get { return "Peperoni Pizza"}
    }
    
    override init() {
        super.init()
        // NOTE: It feels natural to use Decorator for this
        toppings = ["Papeeroni", "Onoion", "Cherry", "Chedar"]
    }
}

class HawaiPizza : Pizza {
    override var name: String {
        get { return "Hawai Pizza"}
    }
    
    override init() {
        super.init()
        toppings = ["Pinaple", "Ham", "Onion", "Mozarella"]
    }
}

class MargaritaPizza : Pizza {
    override var name: String {
        get { return "Margarita Pizza"}
    }
    
    override init() {
        super.init()
        toppings = ["Mozarella"]
    }
}

class SimplePizzaFactory {
    func createPizza (name: String) -> Pizza? {
        switch name {
            case "Peperoni":
                return PeperoniPizza()
            case "Hawai":
                return HawaiPizza()
            case "Margarita":
                return MargaritaPizza()
            default:
                return nil
        }
    }
}

class PizzaStore {
    let pizzaFactory: SimplePizzaFactory
    
    init (_ factory: SimplePizzaFactory) {
        self.pizzaFactory = factory
    }
    
    func orderPizza(type: String) {
        print("You just ordered a \(type) pizza.")
        if let pizza = pizzaFactory.createPizza(type) {
            print("Ok. Will be in 20 minutes...")
            pizza.prepare()
            pizza.bake()
            pizza.cut()
            pizza.box()
            print("Here you are: \(pizza.name)\n")
        } else {
            print("Sorry, we have no \(type)\n")
        }
    }
}

let store = PizzaStore(SimplePizzaFactory())

store.orderPizza("Hawai")
store.orderPizza("Peperoni")
store.orderPizza("Margarita")
store.orderPizza("Swiftita")

// TODO: Expand example to show benifits

