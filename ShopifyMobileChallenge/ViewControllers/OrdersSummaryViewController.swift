//
//  ViewController.swift
//  ShopifyMobileChallenge
//
//  Created by Drake Morin on 2018-05-10.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import UIKit

let kOrderCellReuseIdentifier = "OrderSummaryTableViewCell"

class OrdersSummaryViewController: UIViewController {
    @IBOutlet private weak var emptyStateLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var ordersTableView: UITableView!

    private let viewModel: OrdersSummaryViewModel = OrdersSummaryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib.init(nibName: kOrderCellReuseIdentifier, bundle: nil)
        ordersTableView.register(nib, forCellReuseIdentifier: kOrderCellReuseIdentifier)

        ordersTableView.dataSource = self
        ordersTableView.delegate = self

        bindViewModel()
    }
}

// MARK: - View Binding

private extension OrdersSummaryViewController {
    func bindViewModel() {
        viewModel.hasRequestInProgress.bind(to: loadingIndicator.reactive.isAnimating)
        viewModel.hasRequestInProgress.bind(to: ordersTableView.reactive.isHidden)
        viewModel.hasRequestInProgress.bind(to: emptyStateLabel.reactive.isHidden)

        viewModel.isEmptyStateHidden.bind(to: emptyStateLabel.reactive.isHidden)

        viewModel.shouldReloadView
            .observeNext {
                self.ordersTableView.reloadData()
            }
            .dispose(in: reactive.bag)

        viewModel.errorMessages
            .observeNext { [unowned self] errorMessage in
                let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                self.present(alertController, animated: true)
            }
            .dispose(in: reactive.bag)
    }
}

// MARK: - TableView Data Source

extension OrdersSummaryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "By Province"
        } else {
            return "By Year"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.ordersByProvince.count
        } else {
            return viewModel.ordersByYear.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kOrderCellReuseIdentifier) as! OrderSummaryTableViewCell

        if indexPath.section == 0 {
            let province = viewModel.ordersByProvince.keys.sorted()[indexPath.row]
            let count = viewModel.ordersByProvince[province] ?? 0

            cell.inject(name: province, count: count)
        } else {
            let year = viewModel.ordersByYear.keys.sorted()[indexPath.row]
            let count = viewModel.ordersByYear[year] ?? 0

            cell.inject(name: "\(year)", count: count)
        }

        return cell
    }
}

// MARK: - TableView Delegate

extension OrdersSummaryViewController: UITableViewDelegate { }

