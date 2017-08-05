//: Playground - noun: a place where people can play

import UIKit

struct Property {
    var name: String
    var type: String
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}

import UIKit

class ObjectToBuild {
    let prop1: String
    let prop2: Int
    init(prop1: String, prop2: Int) {
        self.prop1 = prop1
        self.prop2 = prop2
    }
}

let objToBuild = ObjectToBuild(prop1: "testString", prop2: 1234)

var className = String(describing: type(of: objToBuild))
var properties : [Property] = []

for reflection in Mirror(reflecting: objToBuild).children {
    if let label = reflection.label {
        let type = type(of: reflection.value)
        properties.append(Property(name: label, type: String(describing: type)))
    }
}

func printVars() {
    for property in properties {
        print("var \(property.name): \(property.type)")
    }
}
func printKeys() {
    for property in properties {
        print("static let \(property.name)Key = \"\(property.name)\"")
    }
}

func printInit() {
    var initString: String = "init("
    for property in properties {
        initString.append("\(property.name): \(property.type), ")
    }
    let endIndex = initString.index(initString.endIndex, offsetBy: -2)
    initString = initString.substring(to: endIndex)
    initString.append(") {\n")
    for property in properties {
        initString.append("    self.\(property.name) = \(property.name)\n")
    }
    initString.append("}")
    print(initString)
}

func printFluent() {
    var fluentString: String = "init(row: Row) throws {\n"
    for property in properties {
        var keyName = "\(property.name)Key"
        fluentString.append("    \(property.name) = try row.get(\(className).\(keyName))\n")
    }
    fluentString.append("}")
    print(fluentString)
}

func printMakeRow() {
    var string: String = "func makeRow() throws -> Row {\n"
    string.append("    var row = Row()\n")
    for property in properties {
        var keyName = "\(property.name)Key"
        var staticName = "\(className).\(keyName)"
        string.append("    try row.set(\(staticName), \(property.name))\n")
    }
    string.append("    return row\n")
    string.append("}")
    print(string)
}
func printPrepare() {
    var string: String = "try database.create(self) { builder in\n    builder.id()\n"
    for property in properties {
        var keyName = "\(property.name)Key"
        string.append("    builder.string(\(className).\(keyName))\n")
    }
    string.append("}")
    print(string)
}

func printJsonInit() {
    var string: String = "try self.init(\n"
    for property in properties {
        var keyName = "\(property.name)Key"
        var staticName = "\(className).\(keyName)"
        string.append("    \(property.name): json.get(\(staticName)),\n")
    }
    string.append(")")
    print(string)
}
func printMakeJson() {
    var string: String = "func makeJSON() throws -> JSON {\n"
    string.append("    var json = JSON()\n")
    string.append("    try json.set(\(className).idKey, id)\n")
    for property in properties {
        var keyName = "\(property.name)Key"
        var staticName = "\(className).\(keyName)"
        string.append("    try json.set(\(staticName), \(property.name))\n")
    }
    string.append("    return json\n")
    string.append("}")
    print(string)
}
printVars()
printKeys()
printInit()
printFluent()
printMakeRow()
printPrepare()
printJsonInit()
printMakeJson()
