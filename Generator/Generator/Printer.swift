//
//  Printer.swift
//  Generator
//
//  Created by Miguel de Icaza on 4/19/23.
//

import Foundation

public class Printer {
    // Where we accumulate our output for the p/b routines
    var result = ""
    var indentStr = ""          // The current indentation string, based on `indent`
    var indent = 0 {
        didSet {
            indentStr = String (repeating: "    ", count: indent)
        }
    }

    func preamble () {
        p ("// This file is autogenerated, do not edit\n")
        p ("import Foundation\n")
        p ("@_implementationOnly import GDExtension\n")

    }
    
    // Prints the string, indenting any newlines with the current indentation
    func p (_ str: String) {
        for x in str.split(separator: "\n", omittingEmptySubsequences: false) {
            print ("\(indentStr)\(x)", to: &result)
        }
    }

    // Prints a block, automatically indents the code in the closure
    func b (_ str: String, suffix: String = "", block: () -> ()) {
        p (str + " {")
        indent += 1
        block ()
        indent -= 1
        p ("}\(suffix)\n")
    }

    func callAsFunction(_ str: String) {
        p (str)
    }
    
    func callAsFunction(_ str: String, suffix: String = "", block: () -> ()) {
        b (str, suffix: suffix, block: block)
    }
    
    func save (_ file: String) {
        try! result.write(toFile: file, atomically: true, encoding: .utf8)
    }
}
