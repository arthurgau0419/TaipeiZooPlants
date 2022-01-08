//
//  ViewModel.swift
//  TaipeiZooPlants
//
//  Created by Arthur Kao on 2022/1/8.
//

import Foundation

class ViewModel {
        
    typealias Plant = OpenDataPlantsProvider.Plant
    
    // Remote
    let plantsProvider = OpenDataPlantsProvider()
    // Mock
//    let plantsProvider = MockPlantsProvider()
    
    
    init() {}
        
    var plants: [Plant] = []
    
        
    var hudStatus: HudStatus = .off {
        didSet {
            outputDelegate?.hudStatus(hudStatus)
        }
    }
    
    /// Inputs
    
    func willDisplayIndex(_ index: Int) {
        guard index != 0 else { return }
        if index == max(0, plants.count - 1) {
            reload()
        }
    }
    
    func reload() {
        Task(priority: .medium) {
            await MainActor.run {
                hudStatus = .loading
            }
            do {
                let plants = try await plantsProvider.fetchPlants(limit: 20, offset: plants.count)
                self.plants.append(contentsOf: plants)
                await MainActor.run {
                    if plants.isEmpty {
                        hudStatus = .message("沒有更多資料了", false)
                    } else {
                        hudStatus = .off
                        outputDelegate?.reloadTable()
                        outputDelegate?.countLabelText("Count: \(self.plants.count)")
                    }
                }
            } catch {
                await MainActor.run {
                    hudStatus = .message(error.localizedDescription, true)
                }
            }
        }
    }
    
    /// Outputs
    var outputDelegate: ViewModelOutputDelegate?
}

protocol ViewModelOutputDelegate {
    
    func reloadTable()
    
    func countLabelText(_ text: String?)
    
    func hudStatus(_ status: ViewModel.HudStatus)
}

extension ViewModel {
    
    enum HudStatus {
        case message(String, _ isError: Bool)
        case loading
        case off
    }
}
