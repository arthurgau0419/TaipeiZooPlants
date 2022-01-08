//
//  ViewController.swift
//  TaipeiZooPlants
//
//  Created by Arthur Kao on 2022/1/7.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet
    weak var tableView: UITableView!
    
    @IBOutlet
    weak var barExtendView: UIView!
    
    @IBOutlet
    weak var tableHeaderView: UIView!
    
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

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
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
}
