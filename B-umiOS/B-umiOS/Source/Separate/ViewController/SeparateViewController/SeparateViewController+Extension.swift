//
//  SeparateViewController+Extension.swift
//  B-umiOS
//
//  Created by 홍진석 on 2021/07/06.
//

import SnapKit
import UIKit

// MARK: - UICollectionViewDelegateFlowLayout

extension SeparateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 128 * (UIScreen.main.bounds.width / 375), height: 152 * (UIScreen.main.bounds.width / 375))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 44 * (UIScreen.main.bounds.width / 375), bottom: 0, right: 44 * (UIScreen.main.bounds.width / 375))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20 * (UIScreen.main.bounds.width / 375)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        30 * (UIScreen.main.bounds.width / 375)
    }
}

// MARK: - UICollectionViewDataSource

extension SeparateViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tag.count < 8 {
            return tag.count + 1
        }
        return tag.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeparateCollectionViewCell.identifier, for: indexPath) as? SeparateCollectionViewCell else {
            return UICollectionViewCell()
        }

        if indexPath.row == tag.count {
            cell.setData(name: "추가하기", index: 0, count: 0)
        }

        else {
            let separate = tag[indexPath.row]
            cell.setData(name: separate.name, index: separate.index , count: separate.count)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SeparateViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if(indexPath.row == tag.count){
            let nextVC = SeparatePopUpViewController(method: .add)
            
            nextVC.delegate = self
            nextVC.modalPresentationStyle = .overFullScreen
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true, completion: nil)
            
        }
        else {
            let vc = tag[indexPath.row].count >= 5 ? SeparatePresentPopUpViewController() : SeparateToastViewController()
            
            if let nextVC = vc as? SeparatePresentPopUpViewController{
                nextVC.popupdelegate = self
                nextVC.indexPath_row = indexPath.row
            }
            
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.tabBarController?.present(vc, animated: true, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SeperateHeaderView.identifier, for: indexPath)

            return headerView
        default:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SeperateFooterView.identifier, for: indexPath)

            return footerView
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: SizeConstants.screenWidth, height: 72 * SizeConstants.screenRatio)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: SizeConstants.screenWidth, height: 100 * SizeConstants.screenRatio)
    }
}

extension SeparateViewController: ChangeCategoryDataDelegate {
    func changeCategoryData(data: [Category]) {
        tag = data
        separateCollectionView.reloadData()
    }
}

extension SeparateViewController: popupDelegate{
    func closeBottomSheet() {}
    
    func sendData<T>(data: T) {
        guard let index = data as? Int else { return }

        ActivityIndicator.shared.startLoadingAnimation()
        
        CategoryService.shared.fetchRewardData(category_id: tag[index].id) { response in
            guard let result = response as? NetworkResult<Any> else{return}
            ActivityIndicator.shared.stopLoadingAnimation()
            switch result{
            case .success(let response):
                guard let reward = response as? GeneralResponse<RewardResponse> else{return}

                let vc = MyRewardPopUpViewController(reward: reward.data!.reward)
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                self.tabBarController?.present (vc, animated: true)
            default:
                break
            }
        }

        self.tag[index].count = 0
        self.separateCollectionView.reloadData()
    }

}
