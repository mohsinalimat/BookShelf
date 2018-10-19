//
//  BestSellerDVC.swift
//  Books
//
//  Created by Winston Maragh on 10/18/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class BestSellerDVC: UIViewController {

    let bestSellerDetailView = BestSellerDetailView()
    
    var book: NYTBestSellerBook!

    init(book: NYTBestSellerBook) {
        super.init(nibName: nil, bundle: nil)
        self.book = book
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomView()
        setupNavBar()
        bestSellerDetailView.bookReviewButton.addTarget(self, action: #selector(bookReviewButtonPressed), for: .touchUpInside)
        bestSellerDetailView.amazonButton.addTarget(self, action: #selector(amazonButtonPressed), for: .touchUpInside)
        bestSellerDetailView.saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = book.categoryName
    }
    
    private func setupCustomView() {
        self.view = bestSellerDetailView
        bestSellerDetailView.configureView(book: book)
    }
    
    private func setupNavBar(){
        self.navigationItem.title = book.categoryName
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "favorite"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(favoritePressed))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func favoritePressed() {
        let favoriteVC = FavoriteVC()
        self.navigationController?.pushViewController(favoriteVC, animated: true)
    }
    
    @objc func amazonButtonPressed() {
        if !book.amazonURLString.isEmpty {
            let webVC = WebVC(link: book.amazonURLString)
            webVC.title = "Buy on Amazon"
            webVC.navigationItem.title = "Buy on Amazon"
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    @objc func bookReviewButtonPressed() {
        if !book.review.isEmpty {
            let webVC = WebVC(link: book.review)
            webVC.title = "NYTimes Review"
            webVC.navigationItem.title = "NYTimes Review"
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    @objc func saveButtonPressed() {
        if bestSellerDetailView.saveButton.image(for: .normal) == UIImage(named: "like_empty") {
            FileManagerService.shared.addFavoriteBook(book: book)
            bestSellerDetailView.saveButton.setImage(UIImage(named: "like_filled"), for: .normal)
            showBookAddedAlert()
        } else {
            FileManagerService.shared.deleteFavoriteBook(book: book)
            bestSellerDetailView.saveButton.setImage(UIImage(named: "like_empty"), for: .normal)
        }
    }
    
    private func showBookAddedAlert(){
        let alertController = UIAlertController(title: "Book Added", message: "Added to your favorites", preferredStyle: .alert)
        let okAlert = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAlert)
        present(alertController, animated: true, completion: nil)
    }
    
}
