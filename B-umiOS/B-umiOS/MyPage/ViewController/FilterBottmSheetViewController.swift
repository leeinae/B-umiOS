//
//  MyWritingPopUpViewController.swift
//  B-umiOS
//
//  Created by kong on 2021/07/07.
//
import Then
import SnapKit
import UIKit

class FilterBottmSheetViewController: UIViewController {
    // MARK: - UIComponenets
    
    private let popupView = UIView().then {
        $0.cornerRound(radius: 10)
        $0.backgroundColor = .white
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    private let confirmButton = UIButton().then {
        $0.cornerRound(radius: 10)
        $0.backgroundColor = .blue2Main
        $0.tintColor = .white
        $0.setTitle("확인", for: .normal)
    }
    
    private lazy var categoryTagCollecitonView : UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(WritingTagCollectionViewCell.self, forCellWithReuseIdentifier: WritingTagCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private lazy var categoryLabel = UILabel().then {
        $0.font = UIFont.nanumSquareFont(type: .extraBold, size: 20)
        $0.textColor = .header
        $0.text = "카테고리"
    }
    
    private var settingPeriodView = UIView().then {
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
    }
    
    private var datePickerView: UIDatePicker = {
        var picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KO")
        var components = DateComponents()
        
        components.year = 10
        let maxDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        components.year = -10
        let minDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        
        picker.maximumDate = maxDate
        picker.minimumDate = minDate
        picker.addTarget(self, action: #selector(datePickerIsChanged(_:)), for: .valueChanged)
        
        return picker
    }()
    
    private lazy var startDateButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitleColor(.iconGray, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(datePickerButtonSelected(_:)), for: .touchUpInside)
        $0.isHidden = true
    }
    
    private var startDateLine = UIView()
    
    private var endDateLine = UIView()
    
    private var startLabel = UILabel().then{
        $0.font = UIFont.nanumSquareFont(type: .regular, size: 14)
        $0.textColor = .green2Main
        $0.text = "시작"
        $0.isHidden = true
    }
    
    private var endLabel = UILabel().then {
        $0.font = UIFont.nanumSquareFont(type: .regular, size: 14)
        $0.textColor = .iconGray
        $0.text = "끝"
        $0.isHidden = true
    }
    
    private lazy var endDateButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitleColor(.iconGray, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(datePickerButtonSelected(_:)), for: .touchUpInside)
        $0.isHidden = true
    }
    
    private lazy var setDateLabel = UILabel().then {
        $0.font = UIFont.nanumSquareFont(type: .extraBold, size: 20)
        $0.textColor = .header
        $0.text = "기간 설정"
    }
    
    private var dateSwitch = UISwitch().then {
        $0.isOn = false
        $0.onTintColor = .green2Main
        $0.addTarget(self, action: #selector(switchDidTap(_:)), for: .touchUpInside)
    }
    
    private let rect = UIView().then {
        $0.backgroundColor = .paper1
        $0.cornerRound(radius: 10)
    }
    
    private  let backgroundButton = UIButton().then {
        $0.addTarget(self, action: #selector(didTapBackgroundButton(_:)), for: .touchUpInside)
    }
    
    // MARK: - Properties
    
    var subText : String = "sub view"
    var placeholder : String = "placeholder"
    var tag: [String] = ["인간관계", "취업", "날파리", "거지챌린지", "아르바이트", "부장님"]
    var selecetedStartDatePicker : Bool = true
    let dateFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_KO")
        $0.dateFormat = "yyyy.MM.dd(E)"
    }
    
    
    // MARK: - Initializer
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        setConstraint()
        setFirstDatePicker()
    }
    
    // MARK: - Actions
    
    @objc private func didTapBackgroundButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func datePickerIsChanged(_ sender: UIPickerView){
        if (selecetedStartDatePicker) {
            let dateText = dateFormatter.string(from: datePickerView.date)
            startDateButton.setTitle(dateText, for: .normal)
            //여기서 시작 끝 날짜 제한 구현
        } else {
            let dateText = dateFormatter.string(from: datePickerView.date)
            endDateButton.setTitle(dateText, for: .normal)
        }
    }
    
    @objc private func datePickerButtonSelected(_ sender: UIButton) {
        let dateString = sender.currentTitle
        let date = dateFormatter.date(from: dateString!)
        datePickerView.date = date!
        
        if sender == startDateButton {
            print("startDateButton")
            selecetedStartDatePicker = true;
            startDateLine.backgroundColor = .green2Main
            startLabel.textColor = .green2Main
            endDateLine.backgroundColor = .disable
            endLabel.textColor = .iconGray
        } else {
            print("endDateButton")
            selecetedStartDatePicker = false
            startDateLine.backgroundColor = .disable
            startLabel.textColor = .iconGray
            endDateLine.backgroundColor = .green2Main
            endLabel.textColor = .green2Main
        }
    }
    
    @objc private func switchDidTap(_ sender: UISwitch) {
        if sender.isOn {
            settingPeriodView.snp.updateConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.equalTo(categoryLabel.snp.top).offset(-34)
                make.height.equalTo(220)
            }
            startLabel.isHidden = false
            startDateButton.isHidden = false
            endLabel.isHidden = false
            endDateButton.isHidden = false
        } else {
            settingPeriodView.snp.updateConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.equalTo(categoryLabel.snp.top).offset(-34)
                make.height.equalTo(0)
            }
    }
    }
    // MARK: - Methods
    
    func setConstraint() {
        self.view.addSubviews([backgroundButton,popupView])
        popupView.addSubviews([confirmButton, categoryTagCollecitonView, categoryLabel, settingPeriodView, setDateLabel, dateSwitch])
        settingPeriodView.addSubviews([datePickerView, startDateButton,endDateButton,startDateLine, endDateLine, startLabel, endLabel])

        backgroundButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        popupView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(setDateLabel.snp.top).offset(-40)
            make.leading.trailing.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(42)
            make.height.equalTo(50)
        }
        
        categoryTagCollecitonView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.bottom.equalTo(confirmButton.snp.top).offset(30)
            make.leading.trailing.equalTo(confirmButton)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.bottom.equalTo(categoryTagCollecitonView.snp.top).offset(-22)
            make.leading.equalTo(confirmButton)
        }
        
        settingPeriodView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(categoryLabel.snp.top).offset(-34)
            make.height.equalTo(0)
        }
        
        startLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(startLabel).offset(8)
        }
        
        endLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(endDateLine).offset(8)
        }
        
        startDateButton.snp.makeConstraints { make in
            make.top.equalTo(startLabel.snp.bottom).offset(3)
            make.leading.equalTo(startLabel)
            make.height.equalTo(28)
        }
        
        endDateButton.snp.makeConstraints { make in
            make.top.equalTo(endLabel.snp.bottom).offset(3)
            make.leading.equalTo(endLabel)
            make.height.equalTo(28)
        }
        
        startDateLine.snp.makeConstraints { make in
            make.top.equalTo(startDateButton.snp.bottom)
            make.leading.equalToSuperview()
            make.width.equalTo((SizeConstants.ScreenWidth - 55)/2)
            make.height.equalTo(2)
        }
        
        endDateLine.snp.makeConstraints { make in
            make.top.equalTo(endDateButton.snp.bottom)
            make.width.equalTo((SizeConstants.ScreenWidth - 55)/2)
            make.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
        
        datePickerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(140)
        }
        
        
        setDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(confirmButton)
            make.bottom.equalTo(settingPeriodView.snp.top).offset(-24)
        }
        
        dateSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(setDateLabel)
        }
    }
    
    func setFirstDatePicker(){
        //익스텐션 사용하는 걸로 수정할게요
        let nowDateTime = Date();
        let tmpDateFormatter = DateFormatter();
        tmpDateFormatter.dateFormat = "yyyy.MM.dd(E)"
        
        startDateLine.backgroundColor = .green2Main
        endDateLine.backgroundColor = .disable
        
        startDateButton.setTitle(dateFormatter.string(from: nowDateTime), for: .normal)
        endDateButton.setTitle(dateFormatter.string(from: nowDateTime), for: .normal)
    }
}

// MARK: - Protocols
// MARK: - Extensions
extension FilterBottmSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = tag[indexPath.row]
        label.font = UIFont.nanumSquareFont(type: .regular, size: 16)
        label.sizeToFit()
        
        return CGSize(width: label.bounds.width + 32, height: label.bounds.height + 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}
// MARK: - UICollectionViewDataSource

extension FilterBottmSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WritingTagCollectionViewCell.identifier, for: indexPath) as? WritingTagCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setTagLabel(tag: tag[indexPath.row])
        return cell
    }
}