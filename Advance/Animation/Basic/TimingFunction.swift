/*

Copyright (c) 2016, Storehouse Media Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

import Foundation
import CoreGraphics

/// Conforming types can be used to convert linear input time (`0.0 -> 1.0`) to transformed output time (also `0.0 -> 1.0`).
public protocol TimingFunction {
    
    /// Transforms the given time.
    ///
    /// - parameter x: The input time (ranges between 0.0 and 1.0).
    /// - parameter epsilon: The required precision of the result (where `x * epsilon` is the maximum time segment to be evaluated).
    /// - returns: The resulting output time.
    func solve(at time: Scalar, epsilon: Scalar) -> Scalar
}

/// Returns the input time, unmodified.
public struct LinearTimingFunction: TimingFunction {
    
    /// Creates a new instance of `LinearTimingFunction`.
    public init(){}
    
    /// Solves for time `x`.
    public func solve(at time: Scalar, epsilon: Scalar) -> Scalar {
        return time
    }
}

/// Output time is calculated as `(1.0-x)`.
public struct ReversedTimingFunction: TimingFunction {
    /// Creates a new instance of `ReversedTimingFunction`.
    public init(){}
    
    /// Solves for time `x`.
    public func solve(at time: Scalar, epsilon: Scalar) -> Scalar {
        return 1.0 - time
    }
}


extension UnitBezier: TimingFunction {
    
    /// Solves for time `x`.
    public func solve(at time: Scalar, epsilon: Scalar) -> Scalar {
        return solve(x: time, epsilon: epsilon)
    }
}

public extension UnitBezier {
    
    /// A set of preset bezier curves.
    public enum Preset {
        /// Equivalent to `kCAMediaTimingFunctionDefault`.
        case `default`
        
        /// Equivalent to `kCAMediaTimingFunctionEaseIn`.
        case easeIn
        
        /// Equivalent to `kCAMediaTimingFunctionEaseOut`.
        case easeOut
        
        /// Equivalent to `kCAMediaTimingFunctionEaseInEaseOut`.
        case easeInEaseOut
        
        /// No easing.
        case linear
        
        /// Inspired by the default curve in Google Material Design.
        case swiftOut
    }
    
    /// Initializes a UnitBezier with a preset.
    public init(preset: Preset) {
        switch preset {
        case .default:
            self = UnitBezier(p1x: 0.25, p1y: 0.1, p2x: 0.25, p2y: 1.0)
        case .easeIn:
            self =  UnitBezier(p1x: 0.42, p1y: 0.0, p2x: 1.0, p2y: 1.0)
        case .easeOut:
            self =  UnitBezier(p1x: 0.0, p1y: 0.0, p2x: 0.58, p2y: 1.0)
        case .easeInEaseOut:
            self =  UnitBezier(p1x: 0.42, p1y: 0.0, p2x: 0.58, p2y: 1.0)
        case .linear:
            self =  UnitBezier(p1x: 0.0, p1y: 0.0, p2x: 1.0, p2y: 1.0)
        case .swiftOut:
            self =  UnitBezier(p1x: 0.4, p1y: 0.0, p2x: 0.2, p2y: 1.0)
        }
    }
}
