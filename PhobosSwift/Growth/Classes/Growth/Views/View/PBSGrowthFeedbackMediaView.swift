//
//
//  PBSGrowthFeedbackMediaView.swift
//  PhobosSwiftGrowth
//
//  Copyright (c) 2021 Restless Codes Team (https://github.com/restlesscode/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import PhobosSwiftCore
import RxCocoa
import RxSwift
import SnapKit

class PBSGrowthFeedbackMediaView: UIView {
  var viewModel: PBSGrowthFeedbackViewModel?

  var addedClick = PublishRelay<Bool>()
  var removeClick = PublishRelay<Int>()

  let titleLabel = UILabel()
  let countLabel = UILabel()

  lazy var layout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    return layout
  }()

  lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.delegate = self
    view.dataSource = self
    view.backgroundColor = .clear
    view.register(AddMediaCell.self, forCellWithReuseIdentifier: AddMediaCell.id)
    view.register(MediaCell.self, forCellWithReuseIdentifier: MediaCell.id)
    view.showsVerticalScrollIndicator = false
    view.showsHorizontalScrollIndicator = false
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    addSubview(titleLabel)
    addSubview(countLabel)
    titleLabel.text = "Media"
    titleLabel.textColor = .white
    titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

    countLabel.text = "0"
    countLabel.textColor = .pbs.color(R: 158, G: 158, B: 167)
    countLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(11)
      make.left.equalToSuperview().offset(20)
      make.height.equalTo(33)
    }
    countLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(11)
      make.right.equalToSuperview().offset(-20)
      make.height.equalTo(33)
    }
    addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(55)
      make.left.right.equalToSuperview()
      make.height.equalTo(90)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension PBSGrowthFeedbackMediaView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    (viewModel?.dataCount ?? 0) + 1
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.row == 0 {
      return collectionView.dequeueReusableCell(withReuseIdentifier: AddMediaCell.id, for: indexPath)
    }
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCell.id, for: indexPath)
    if let cell = cell as? MediaCell {
      cell.indexPath = indexPath
      _ = cell.removeMedia.asObservable().subscribe { [weak self] event in
        guard let self = self else { return }
        if case let .next(value) = event {
          self.removeClick.accept(value)
        }
      }
      cell.image.image = viewModel?.imageModel(at: indexPath.row - 1)?.image
    }
    return cell
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    (indexPath.row == 0) ? AddMediaCell.itemSize : MediaCell.itemSize
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      addedClick.accept(true)
      return
    }
  }
}

extension PBSGrowthFeedbackMediaView {
  class AddMediaCell: UICollectionViewCell, PBSUIInterface {
    static let itemSize = CGSize(width: 90, height: 90)
    let backView = UIView()
    let image = UIImageView()
    let titleLabel = UILabel()
    override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = .clear

      addSubview(backView)
      backView.addSubview(image)
      backView.addSubview(titleLabel)

      backView.backgroundColor = .pbs.color(R: 44, G: 44, B: 46)
      backView.layer.cornerRadius = 8

      if #available(iOS 13.0, *) {
        image.image = UIImage(systemName: "camera.fill")
      }
      image.contentMode = .scaleAspectFit
      image.tintColor = .white

      titleLabel.text = "Add photos"
      titleLabel.textAlignment = .center
      titleLabel.textColor = .pbs.color(R: 158, G: 158, B: 167)
      titleLabel.font = .systemFont(ofSize: 12, weight: .regular)

      backView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }
      image.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(20)
        make.centerX.equalToSuperview()
        make.width.height.equalTo(33)
      }
      titleLabel.snp.makeConstraints { make in
        make.top.equalTo(image.snp.bottom).offset(6)
        make.height.equalTo(17)
        make.left.right.equalToSuperview()
      }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

  class MediaCell: UICollectionViewCell, PBSUIInterface {
    static let itemSize = CGSize(width: 135, height: 90)
    let backView = UIView()
    let image = UIImageView()
    let cancelButton = UIButton()
    var indexPath: IndexPath?
    var removeMedia = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = .clear
      backView.layer.cornerRadius = 8
      backView.layer.masksToBounds = true

      addSubview(backView)
      backView.addSubview(image)
      backView.addSubview(cancelButton)

      image.contentMode = .scaleAspectFill
      image.tintColor = .white

      if #available(iOS 13.0, *) {
        cancelButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        cancelButton.tintColor = .white
      }

      backView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }
      image.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }
      cancelButton.snp.makeConstraints { make in
        make.width.height.equalTo(33)
        make.top.right.equalToSuperview()
      }
      cancelButton
        .rx
        .controlEvent(.touchUpInside)
        .throttle(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] in
          guard let self = self, let value = self.indexPath?.row else { return }
          self.removeMedia.accept(value - 1)
        }).disposed(by: disposeBag)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}
