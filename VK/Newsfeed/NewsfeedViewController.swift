//
//  NewsfeedViewController.swift
//  VK
//
//  Created by Сергей Насыбуллин on 22.09.2023.
//  Copyright (c) 2023 NasybullinSergei. All rights reserved.
//

import UIKit 

protocol NewsfeedDisplayLogic: AnyObject {
    func displaySomething(viewModel: Newsfeed.Something.ViewModel.ViewModelType)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic, NewsfeedCodeCellDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    var interactor: NewsfeedBusinessLogic?
    var router: (NSObjectProtocol & NewsfeedRoutingLogic)?
    
    private var feedViewModel = FeedViewModel(cells: [], footerTitle: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    private var titleView = TitleView()
    
    private lazy var footerView = FooterView()
    
    private var blurGradientView: BlurGradientView = {
        let blurGradientView = BlurGradientView()
        blurGradientView.locationsGradient = [0.6, 1]
        blurGradientView.colors = [
            CGColor(gray: 1, alpha: 1),
            CGColor(gray: 0, alpha: 0)
        ]
        return blurGradientView
    }()
    
    
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
//        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = NewsfeedInteractor()
        let presenter = NewsfeedPresenter()
        let router = NewsfeedRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        setupTopBars()
        setupTable()
        setupBlure()
        
        interactor?.doSomething(request: .getNewsfeed)
        interactor?.doSomething(request: .getUser)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let height = getStatusBarFrame().size.height * 2
        let size = CGSize(width: getStatusBarFrame().size.width, height: height)
        blurGradientView.frame = CGRect(origin: .zero, size: size)
    }
    

    func setupBlure() {
        self.view.addSubview(blurGradientView)
    }
    
    
    func getStatusBarFrame() -> CGRect {
        var statusBarFrame: CGRect = .zero
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        return statusBarFrame
    }
    
    
    private func setupTable() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.backgroundColor = #colorLiteral(red: 0.03529411765, green: 0.03529411765, blue: 0.03529411765, alpha: 1)
        tableView.register(NewsfeedCodeCell.self, forCellReuseIdentifier: NewsfeedCodeCell.reuseId)
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = footerView
    }
    
    
    
    private func setupTopBars() {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
    }
    
    
    @objc private func refresh() {
        interactor?.doSomething(request: .getNewsfeed)
    }
    
    
    // MARK: Display Something
    
    func displaySomething(viewModel: Newsfeed.Something.ViewModel.ViewModelType) {
        switch viewModel {
        case .displayNewsfeed(feedViewModel: let feedViewModel):
            self.feedViewModel = feedViewModel
            footerView.setTitle(feedViewModel.footerTitle)
            tableView.reloadData()
            refreshControl.endRefreshing()
        case .displayUser(userViewModel: let userViewModel):
            self.titleView.set(userViewModel: userViewModel)
        case .displayFooterLoader:
            footerView.showLoader()
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.doSomething(request: .getNextBatch)
        }
    }
    
    
    // MARK: NewsfeedCodeCellDelegate
    
    func revealPost(for cell: NewsfeedCodeCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        interactor?.doSomething(request: Newsfeed.Something.Request.RequestType.revealPostId(postId: cellViewModel.postId))
    }
    
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { feedViewModel.cells.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCodeCell.reuseId, for: indexPath) as! NewsfeedCodeCell
        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        feedViewModel.cells[indexPath.row].sizes.totalHeight
    }
 
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        feedViewModel.cells[indexPath.row].sizes.totalHeight
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
}
