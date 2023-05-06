//
//  File.swift
//  
//
//  Created by Miguel de Icaza on 3/28/23.
//

import Foundation
@_implementationOnly import GDExtension

/// Protocol implemented by the built-in classes in Godot to allow to be wrapped in a ``Variant``
public protocol GodotVariant {
    func toVariant () -> Variant
    init? (_ fromVariant: Variant)
}

/// This represents a typed array of one of the built-in types from Godot
public class VariantCollection<T:GodotVariant>: GArray, Collection {
    override init (content: Int64) {
        super.init (content: content)
    }
    
    public override init () {
        super.init ()
        var name = StringName()
        var variant = Variant()

        //gi.array_set_typed (&content, GDExtensionVariantType (UInt32(T.variantType.rawValue)), &name.content, &variant.content)
    }
    
    public required init? (_ variant: Variant) {
        super.init (variant)
    }
    
    // If I make this optional, I am told I need to implement an internal _read method
    public subscript (index: Index) -> Iterator.Element {
        get {
            var v = super [index]
            return T.init (v)!
        }
        set {
            super [index] = newValue.toVariant()
        }
    }
    
    // Required nested types, that tell Swift what our collection contains
    public typealias Index = Int
    public typealias Element = T
    
    // The upper and lower bounds of the collection, used in iterations
    public var startIndex: Index { 0 }
    public var endIndex: Index { Int (size()) }
    
    // Method that returns the next index when iterating
    public func index(after i: Index) -> Index {
        return i+1
    }
}
