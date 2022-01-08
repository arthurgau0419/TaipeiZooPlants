//
//  TaipeiZooPlantsTests.swift
//  TaipeiZooPlantsTests
//
//  Created by Arthur Kao on 2022/1/8.
//

import XCTest
@testable import TaipeiZooPlants

class TaipeiZooPlantsTests: XCTestCase {
    
    func testNetworkFetchPlantsData() async throws {
        let plants = try await OpenDataPlantsProvider().fetchPlants(limit: 10, offset: 0)
        XCTAssertEqual(plants.count, 10)
    }
    
    func testMaokFetchPlantsData() async throws {
        let provider = MockPlantsProvider()
        let plants = try await provider.fetchPlants(limit: 10, offset: 0)
        XCTAssertEqual(plants.count, 10)
    }
}
