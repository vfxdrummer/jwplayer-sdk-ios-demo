//
//  Random.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/10/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(Linux)
    import Glibc
#else
    import CoreGraphics
    import Security
#endif

private var _instance: Random = {
    srand48(Int(arc4random()))
    return Random()
}()

public struct Random {
    #if os(Linux)
        let m: UInt64 = UInt64(RAND_MAX) + 1
    #else
        let m: UInt64 = 1 << 32
    #endif

    public static var shared: Random {
        get {
            return _instance
        }
    }

#if os(iOS) || os(macOS) || os(tvOS)
    public func cryptoRandom() -> Int32 {
        let a = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
        defer {
            a.deallocate(capacity: 1)
        }
        a.withMemoryRebound(to: UInt8.self, capacity: 4) { p in
            _ = SecRandomCopyBytes(kSecRandomDefault, 4, p)
        }
        let n = a.pointee
        return n
    }
#endif

    // returns a random number in the half-open range 0..<1
    public func number<T: BinaryFloatingPoint>() -> T {
        return T(drand48())
    }

    // returns a random number in the half-open range start..<end
    public func number<T: BinaryFloatingPoint>(_ i: Interval<T>) -> T {
        let n: T = number()
        return n.mapped(to: i)
    }

    // returns an integer in the half-open range start..<end
    public func number(_ i: CountableRange<Int>) -> Int {
        return Int(number(Double(i.lowerBound)..Double(i.upperBound)))
    }

    // returns an integer in the closed range start...end
    public func number(_ i: CountableClosedRange<Int>) -> Int {
        return Int(number(Double(i.lowerBound)..Double(i.upperBound + 1)))
    }

    public func count(_ i: CountableClosedRange<Int>) -> CountableClosedRange<Int> {
        return 0 ... number(i.lowerBound..<i.upperBound)
    }

    // returns a random boolean
    public func boolean() -> Bool {
        return number(0...1) > 0
    }

    // "Generating Gaussian Random Numbers"
    // http://www.taygeta.com/random/gaussian.html

    /// Returns a random number in the range -1.0...1.0 with a Gaussian distribution with zero mean and a standard deviation of one.
    public func gaussian<T: BinaryFloatingPoint>() -> T {
        var x1, x2, w1: Double
        repeat {
            x1 = 2.0 * number() - 1.0
            x2 = 2.0 * number() - 1.0
            w1 = x1 * x1 + x2 * x2
        } while w1 >= 1.0

        let w2 = sqrt( (-2.0 * log(w1)) / 2.0)

        let y1 = x1 * w2
        //let y2 = x2 * w2
        return T(y1)
    }

    public func index(in string: String) -> String.Index {
        let i = number(0..<string.characters.count)
        return string.index(string.startIndex, offsetBy: i)
    }

    public func insertionPoint(in string: String) -> String.Index {
        let i = number(0...string.characters.count)
        return string.index(string.startIndex, offsetBy: i)
    }

    // returns a random number in the half-open range 0..<1
    public static func number<T: BinaryFloatingPoint>() -> T {
        return Random.shared.number()
    }

    public static func number<T: BinaryFloatingPoint>(_ i: Interval<T>) -> T {
        return Random.shared.number(i)
    }

    // returns an integer in the half-open range start..<end
    public static func number(_ i: CountableRange<Int>) -> Int {
        return Random.shared.number(i)
    }

    // returns an integer in the closed range start...end
    public static func number(_ i: CountableClosedRange<Int>) -> Int {
        return Random.shared.number(i)
    }

    public static func count(_ i: CountableClosedRange<Int>) -> CountableClosedRange<Int> {
        return Random.shared.count(i)
    }

    // returns a random boolean
    public static func boolean() -> Bool {
        return Random.shared.boolean()
    }

    public static func choice<T, C: Collection>(among choices: C) -> T where C.IndexDistance == Int, C.Iterator.Element == T {
        let offset = number(Int(0) ..< choices.count)
        let index = choices.index(choices.startIndex, offsetBy: offset)
        return choices[index]
    }

    public static func choice<T>(_ choices: T...) -> T {
        return choice(among: choices)
    }

    public static func gaussian<T: BinaryFloatingPoint>() -> T {
        return Random.shared.gaussian()
    }

    public static func index(in string: String) -> String.Index {
        return Random.shared.index(in: string)
    }

    public static func insertionPoint(in string: String) -> String.Index {
        return Random.shared.insertionPoint(in: string)
    }
}
