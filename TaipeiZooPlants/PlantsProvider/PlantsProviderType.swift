//
//  PlantsProviderType.swift
//  TaipeiZooPlants
//
//  Created by Arthur Kao on 2022/1/8.
//

import Foundation

protocol PlantsProviderType {
    
    associatedtype Plant
    
    func fetchPlants(limit: Int, offset: Int) async throws -> [Plant]
}
