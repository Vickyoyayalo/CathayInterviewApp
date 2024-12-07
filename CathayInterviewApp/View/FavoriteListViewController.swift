//
//  FavoriteListViewController.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/7.
//

import UIKit

class FavoriteListViewController: UIViewController {
    private var tableView: UITableView!
    private let viewModel = FavoriteListViewModel()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        viewModel.fetchFavoriteList(isEmpty: true) // 加載空列表
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: "FavoriteCell")
        view.addSubview(tableView)
        
        // 添加下拉刷新
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func setupBindings() {
        // 綁定 ViewModel 的更新事件
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
        
        viewModel.onError = { [weak self] error in
            self?.showError(error)
        }
    }

    @objc private func refreshData() {
        viewModel.fetchFavoriteList(isEmpty: false) // 加載非空數據
    }

    private func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension FavoriteListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let item = viewModel.item(at: indexPath.row)
        cell.configure(with: item)
        return cell
    }
}

