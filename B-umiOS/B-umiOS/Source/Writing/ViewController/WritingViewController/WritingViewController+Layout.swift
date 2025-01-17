//
//  WritingViewController+layout.swift
//  B-umiOS
//
//  Created by inae Lee on 2021/07/06.
//

import UIKit

extension WritingViewController {
    func setConstraints() {
        navigationView.addSubviews([navigationLabel, backButton, checkButton])
        paperView.addSubviews([titleTextField, textFieldDividerView, textView])
        view.addSubviews([navigationView, navigationDividerView, guideImage, guideLabel, tagCollectionView, leftGradientView, righrGradientView, settingButton, paperView, paperPiece])
   
        navigationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton.snp.centerY)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8 * SizeConstants.screenRatio)
            make.width.height.equalTo(36 * SizeConstants.screenRatio)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        checkButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8 * SizeConstants.screenRatio)
            make.width.height.equalTo(36 * SizeConstants.screenRatio)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        navigationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(SizeConstants.navigationHeight * SizeConstants.screenRatio)
        }
        
        navigationDividerView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        settingButton.snp.makeConstraints { make in
            make.centerY.equalTo(tagCollectionView.snp.centerY)
            make.leading.equalToSuperview().offset(10 * SizeConstants.screenRatio)
            make.width.height.equalTo(48 * SizeConstants.screenRatio)
        }
        
        guideImage.snp.makeConstraints { make in
            make.leading.equalTo(settingButton.snp.trailing).offset(6 * SizeConstants.screenRatio)
            make.centerY.equalTo(settingButton.snp.centerY)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.leading.equalTo(guideImage.snp.trailing).offset(3 * SizeConstants.screenRatio)
            make.centerY.equalTo(guideImage.snp.centerY)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationDividerView.snp.bottom).offset(8)
            make.leading.equalTo(settingButton.snp.trailing)
            make.trailing.equalToSuperview()
            make.height.equalTo(64 * SizeConstants.screenRatio)
        }
        
        leftGradientView.snp.makeConstraints { make in
            make.top.equalTo(navigationDividerView.snp.bottom)
            make.leading.equalToSuperview()
            make.width.equalTo(100 * SizeConstants.screenRatio)
            make.bottom.equalTo(tagCollectionView.snp.bottom)
        }
        
        righrGradientView.snp.makeConstraints { make in
            make.top.equalTo(navigationDividerView.snp.bottom)
            make.trailing.equalToSuperview()
            make.width.equalTo(44 * SizeConstants.screenRatio)
            make.bottom.equalTo(tagCollectionView.snp.bottom)
        }
        
        paperView.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16 * SizeConstants.screenRatio)
            make.bottom.equalToSuperview().offset(10)
        }
        
        paperPiece.snp.makeConstraints { make in
            make.top.trailing.equalTo(paperView)
            make.width.height.equalTo(44 * SizeConstants.screenRatio)
        }
    
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(paperView.snp.top).offset(15)
            make.leading.equalToSuperview().offset(18 * SizeConstants.screenRatio)
            make.width.equalTo(263.0 * SizeConstants.screenRatio)
            make.height.equalTo(titleTextField.snp.width).multipliedBy(32.0 / 263.0)
        }

        textFieldDividerView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(3.8)
            make.leading.trailing.equalTo(titleTextField)
            make.height.equalTo(1)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(textFieldDividerView.snp.bottom).offset(18.8)
            make.leading.trailing.equalToSuperview().inset(17 * SizeConstants.screenRatio)
            make.bottom.equalToSuperview().offset(-53)
        }
    }
}
