//
//  FavoriteListView.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/7.
//

import UIKit

class FavoriteListView: UIView {
    private var tableView: UITableView!
    private let viewModel = FavoriteListViewModel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        setupBindings()
        viewModel.fetchFavoriteList(isEmpty: true) // 初次加载空数据
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: "FavoriteCell")
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension FavoriteListView: UITableViewDataSource, UITableViewDelegate {
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

