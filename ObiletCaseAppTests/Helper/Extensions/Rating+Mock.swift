//
//  Rating+Mock.swift
//  ObiletCaseAppTests
//
//  Created by Burak Gül on 15.08.2024.
//

import Foundation
@testable import ObiletCaseApp

extension Rating {
    static func mockRating(
        rate: Double = 4.5,
        count: Int = 100
    ) -> Rating {
        return Rating(
            rate: rate,
            count: count
        )
    }
}
