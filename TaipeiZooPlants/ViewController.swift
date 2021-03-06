//
//  ViewController.swift
//  TaipeiZooPlants
//
//  Created by Arthur Kao on 2022/1/7.
//

import UIKit
import ProgressHUD
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet
    weak var tableView: UITableView!
    
    @IBOutlet
    weak var barExtendView: UIView!
    
    @IBOutlet
    weak var barExtendStackView: UIView!
    
    @IBOutlet
    weak var tableHeaderView: UIView!
    
    @IBOutlet
    weak var tableHeaderLabel: UILabel!
    
    let viewModel = ViewModel()
    
    var barHeight: CGFloat {
        20 +
        (navigationController?.navigationBar.frame.height ?? .zero) +
        barExtendView.frame.height
    }
    
    var safeAreaTop: CGFloat {
        UIApplication.shared.connectedScenes.compactMap { $0.delegate as? SceneDelegate }.first?
            .window?.safeAreaInsets.top ?? .zero
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.sectionHeaderTopPadding = barHeight + safeAreaTop
        tableHeaderView.layoutMargins.top = safeAreaTop

        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = UIColor(red: 70/255, green: 150/255, blue: 90/255, alpha: 1)
        standardAppearance.shadowColor = .clear
        
        let compactAppearance = standardAppearance.copy()

        let navBar = self.navigationController!.navigationBar
        navBar.standardAppearance = standardAppearance
        navBar.scrollEdgeAppearance = standardAppearance
        navBar.compactAppearance = compactAppearance
        navBar.compactScrollEdgeAppearance = compactAppearance
        
        viewModel.outputDelegate = self
        viewModel.reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.layer.zPosition = -1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.layer.zPosition = 0
    }
}

extension ViewController: ViewModelOutputDelegate {
    
    func reloadTable() { tableView.reloadData() }
    
    func countLabelText(_ text: String?) {
        tableHeaderLabel.text = text
    }
    
    func hudStatus(_ status: ViewModel.HudStatus) {
        switch status {
        case let .message(message, isError):
            if isError {
                ProgressHUD.showError(message)
            } else {
                ProgressHUD.showSucceed(message)
            }
        case .loading:
            ProgressHUD.show()
        case .off:
            ProgressHUD.dismiss()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlantCell
        let plant = viewModel.plants[indexPath.row]
        
        cell.nameLabel.text = plant.name
        cell.locationLabel.text = plant.location
        cell.featureLabel.text = plant.feature
        cell.plantImageView.kf.setImage(with: URL(string: plant.pic))
        print(plant.pic)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42 + safeAreaTop
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplayIndex(indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else { return }
        let ratio: CGFloat
        if tableView.contentOffset.y < 0 {
            ratio = 0
        } else {
            ratio = min(tableView.contentOffset.y, tableView.sectionHeaderTopPadding) /  tableView.sectionHeaderTopPadding
        }
        tableHeaderLabel.alpha = ratio
        navigationItem.titleView?.alpha = 1 - ratio
        barExtendStackView.alpha = 1 - ratio
    }
}
