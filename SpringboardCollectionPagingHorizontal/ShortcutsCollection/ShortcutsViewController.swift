//
//  ShortcutsViewController.swift
//  SpringboardCollectionPagingHorizontal
//
//  Created by Tanya Berezovsky on 26/02/2019.
//  Copyright © 2019 Tanya Berezovsky. All rights reserved.
//

import UIKit

class ShortcutsViewController: UIViewController {
    
    var viewModel: ViewModel = ViewModel() {
        didSet {
            self.data = viewModel.data
            self.leftAndRightPaddings = viewModel.leftAndRightPaddings
            self.numberOfItemsPerRow = viewModel.numberOfItemsPerRow
            self.cellWidth = viewModel.cellWidth
            self.numberOfPages = viewModel.numberOfPages
        }
    }
    private var leftAndRightPaddings: CGFloat = 0 //= 20
    private var numberOfItemsPerRow: CGFloat = 0 //= 3
    var cellWidth: CGFloat = 0//!
    
    private var currentPage: Int = 0 {
        didSet {
            //update UipageControl
            pageControl.currentPage = currentPage
        }
    }
    private var numberOfPages: Int = 0 {
        didSet {
            pageControl.numberOfPages = numberOfPages
        }
    }
    private weak var collectionView: UICollectionView!
    private weak var pageControl: UIPageControl!
    
    private var data = [Shortcuts]()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        let pageControl = UIPageControl(frame: .zero)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.8)

        view.addSubview(pageControl)
        self.pageControl = pageControl

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.pageControl.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            ])
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(SortcutCollectionViewCell.self, forCellWithReuseIdentifier: SortcutCollectionViewCell.identifier)
        self.collectionView.alwaysBounceHorizontal = true
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
    }
}

extension ShortcutsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SortcutCollectionViewCell.identifier, for: indexPath) as! SortcutCollectionViewCell
        let data = self.data[indexPath.item]
        cell.button.setTitle("\(data.cellValue)", for: .normal)
        
        return cell
    }
}

extension ShortcutsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("cell \(indexPath.row) was selected")
    }
}

extension ShortcutsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)//margine
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return leftAndRightPaddings
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return leftAndRightPaddings
    }
}

extension ShortcutsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            self.currentPage = scrollView.currentPage
            // Do something with your page update
            print("scrollViewDidEndDragging: \(currentPage)")
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentPage = scrollView.currentPage
        // Do something with your page update
        print("scrollViewDidEndDecelerating: \(currentPage)")
    }
}

extension UIScrollView {
    var currentPage: Int {
         return Int((self.contentOffset.x + (0.99*self.frame.size.width))/self.frame.width) //+ 1
    }
}

extension ShortcutsViewController {
    struct ViewModel {
        var  data: [Shortcuts] = []
        private var rawdata: [Shortcuts] = []
        lazy var numberOfPages: Int = {
            if rawdata.count == 0 {
                return 0
            }
            return (rawdata.count / cellsOnPage) + ((rawdata.count % cellsOnPage) > 0 ? 1 : 0)
        }()
        
        mutating func calculateDimentions() {
            cellWidth = CGFloat((pageSize.width / numberOfItemsPerRow) - leftAndRightPaddings)
            lines = Int(pageSize.height / ( cellWidth + leftAndRightPaddings))
            cellsOnPage = Int(numberOfItemsPerRow) * lines
        }
        
        var pageSize: CGSize = .zero {
            didSet {
                calculateDimentions()
            }
        }
        let leftAndRightPaddings: CGFloat = 20
        let numberOfItemsPerRow: CGFloat = 3
        private var cellsOnPage: Int!
        var cellWidth: CGFloat!
        private var lines: Int!
        private var twoLinesMapping = [0,3,1,4,2,5]
        private var threeLinesMappingIndex = [0,3,6,1,4,7,2,5,8]
        
    }
}

extension ShortcutsViewController.ViewModel {

    init(rawdata: [Shortcuts], pageSize: CGSize) {
//        if rawdata.count == 0 {
//            return
//        }
        self.rawdata = rawdata
        arrangeDataAcordingToPageSize(pageSize: pageSize)
    }
    private mutating func arrangeDataAcordingToPageSize(pageSize: CGSize) {
        //        if rawdata.count == 0 {
        //            return
        //        }
    //    self.rawdata = rawdata
        self.pageSize = pageSize
        calculateDimentions()
        
        var mappingArr:[Int]?
        if lines == 2 {
            mappingArr = twoLinesMapping
        } else if lines == 3 {
            mappingArr = threeLinesMappingIndex
        }
        if let mappingArr = mappingArr {
            arrangeDataLeftToRight(rawdata, mappingArr: mappingArr)
        } else {
            self.data = rawdata
        }
    }
    private mutating func arrangeDataLeftToRight(_ rawdata: [Shortcuts], mappingArr: [Int]) {
        var index = 0
        data = [Shortcuts]()
        
        (0..<numberOfPages).forEach { pageindex in
            (0..<cellsOnPage).forEach { cellindex in
                index = (pageindex * cellsOnPage) + mappingArr[cellindex]
                if rawdata.count > index {
                    data.append(rawdata[index])
                } else {
                    data.append(Shortcuts(cellValue: "", isHidden: true))
                }
            }
        }
    }
}
