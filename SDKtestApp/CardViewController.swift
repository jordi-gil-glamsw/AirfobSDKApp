/*
* Copyright 2019. Moca System Inc. All Rights Reserved.
*
* This software is the confidential and proprietary information of Moca System Inc. ("Confidential Information").
* You shall not disclose such Confidential Information and shall use it only in accordance with the
* terms of the license agreement you entered into with Suprema.
*/

//
//  CardViewController.swift
//  SDKtestApp
//
//  Created by Jeonjongmin on 2019/11/20.
//  Copyright © 2019 Jeonjongmin. All rights reserved.
//

import UIKit
import SupremaAC
import AudioToolbox
struct ACAccuracyAuthorization {
    static let FullAccuracy = 0
    static let ReducedAccuracy = 1
}
class CardViewController: UIViewController {

    @IBOutlet weak var sdkVersionLabel: UILabel!
    @IBOutlet weak var bleStatusLabel: UILabel!
    @IBOutlet weak var locationStatusLabel: UILabel!
    @IBOutlet weak var enabledBackgroundScan: UISwitch!
    @IBOutlet weak var cardIdLabel: UILabel!
    @IBOutlet weak var preciseLocationLabel: UILabel!
    @IBAction func connectNearestDevice(_ sender: UIButton) {
        SupremaACController.sharedInstance.connectNearestDevice()
    }
    
    private static let siteIdKey = "lastSiteId"
    private static let credentialKey = "lastCredential"
    private static let defaultSiteId = "test"

    // Sample credential shipped with the Suprema demo app. Only opens doors configured with the same site/keys.
    private static let sampleCredential = "WwogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAiY2FyZERhdGEiOiB7CiAgICAgICAgICAgICAgICAgICAgImNhcmROdW1iZXIiOiAiZDEzTHZDemRQVXpCbnJsZGErSmZldz09IiwKICAgICAgICAgICAgICAgICAgICJzdGFydERhdGUiOiAiMCIsCiAgICAgICAgICAgICAgICAgICAiZW5kRGF0ZSI6ICIyNTM0MDIzMDA3OTkwMDAiLAogICAgICAgICAgICAgICAgICAgInJlZnJlc2giOiAiMCIsCiAgICAgICAgICAgICAgICAgICAiY2FyZE51bWJlckJpdCI6ICIyNCIsCiAgICAgICAgICAgICAgICAgICAiZW5jVHlwZSI6ICIzIiwKICAgICAgICAgICAgICAgICAgICJmb3JtYXRDb2RlIjogIjAiLAogICAgICAgICAgICAgICAgICAgInNpZ25hdHVyZSI6ICJNRVFDSUMzbG96L282YjBSa296SGJzNHpQQWthWU9QTm1FQUFmaHNlTVR6SkVWMlJBaUF2eks4RkRIL2ZpR0VZVG1vem9sVlA1MDJqYjdCeUViZzdwMGh0WTB6ck13PT0iCiAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgfSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgImNhcmREYXRhIjogewogICAgICAgICAgICAgICAgICAgICJjYXJkTnVtYmVyIjogInJqcnFEZWd6MktZbWpZcUpFS0VWYmc9PSIsCiAgICAgICAgICAgICAgICAgICAgInN0YXJ0RGF0ZSI6ICIwIiwKICAgICAgICAgICAgICAgICAgICAiZW5kRGF0ZSI6ICIyNTM0MDIzMDA3OTkwMDAiLAogICAgICAgICAgICAgICAgICAgICJyZWZyZXNoIjogIjAiLAogICAgICAgICAgICAgICAgICAgICJjYXJkTnVtYmVyQml0IjogIjI0IiwKICAgICAgICAgICAgICAgICAgICAiZW5jVHlwZSI6ICIzIiwKICAgICAgICAgICAgICAgICAgICAiZm9ybWF0Q29kZSI6ICIwIiwKICAgICAgICAgICAgICAgICAgICAic2lnbmF0dXJlIjogIk1Dd0NGQ3QvbE54ZnhRYmRyZjkxNWFLR0lab3J2cEF1QWhSTDRQRFgrZDhISVQvNzRRSWNJUmpnMlFzUzBBPT0iCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIH0KICAgICAgICBd"

    /// Site id used for the stored card and for SDK initialization. Persisted between launches.
    private var siteId: String {
        get { UserDefaults.standard.string(forKey: Self.siteIdKey) ?? Self.defaultSiteId }
        set { UserDefaults.standard.set(newValue, forKey: Self.siteIdKey) }
    }
    
    @IBAction func changeToggle(_ sender: UISwitch) {
        var isEnabled = sender.isOn
        let status = CLLocationManager().authorizationStatus
        if isEnabled {
            if status != .authorizedAlways {
                let message = "Can be changed when the mobile is set as OS Settings > Privacy > Location Services > Your App > Always."
                self.showAlert(message)
                isEnabled = false
            }
        }
        
        self.setBackgroundScanToggle(isEnabled)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.sdkVersionLabel.text = ACLocalDataManager.getFrameworkVersion()
        self.setBleStatus(status: "Not ready")
        self.initializeSetting()
    }

    private func updateStoredCardLabel() {
        if let cards = ACLocalDataManager.getAcCard(self.siteId), !cards.isEmpty {
            self.cardIdLabel.text = self.siteId
        } else {
            self.cardIdLabel.text = ""
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: "OK", style: .default) { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        alert.addAction(confirmButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setBleStatus(status: String) {
        self.bleStatusLabel.text = status
    }
    
    private func setLocationStatus(status: String, accuracy: String) {
        self.locationStatusLabel.text = status
        self.preciseLocationLabel.text = accuracy
    }
    
    private func setBackgroundScanToggle(_ status: Bool) {
        ACLocalDataManager.setBackgroundScanPermission(status)
        self.enabledBackgroundScan.setOn(status, animated: true)
    }
    
    private func initializeSetting() {
        // 라이센스 발급할 때 사용한 사이트 id
        SupremaACController.sharedInstance.initialize(self.siteId)
        
        SupremaACController.sharedInstance.prefareBLEService({ status in
            self.checkForBLEState(status)
        }, onBLEReady: { isBleReady in
            if isBleReady {
                self.setBleStatus(status: "Ready")
                SupremaACController.sharedInstance.registerBLEStatusBlock { statusStruct in
                    self.doSomethingForBLEProcessStatus(statusStruct)
                }
                self.startScan()
            }
        })
        // api 오타 수정
        // iOS 14로 업데이트 되면서 정확한 위치 옵션 핸들링을 위한 accuracy status 추가
        // 정확한 위치 옵션이 켜져있을 경우 FullAccuracy status로 rawValue는 0이고,
        // 옵션이 꺼져있을 경우 ReducedAccuracy status로 rawValue는 1이다.
        SupremaACController.sharedInstance.prepareLocationService { (status, accuracy) in
            self.checkLocationStatusForBackgroundScan(status, accuracy: accuracy)
        }
        self.updateStoredCardLabel()
    }
    
    private func checkForBLEState(_ state: CBManagerState) {
        switch (state) {
            case .poweredOn:
                self.startScan()
                break
            case .unknown:
                break
            case .resetting:
                break
            case .unsupported:
                break
            case .unauthorized:
                break
            case .poweredOff:
                self.setBleStatus(status: "BLE Power Off")
                break
        }
    }
    
    private func doSomethingForBLEProcessStatus(_ stateStruct: BLEProcessStruct) {
        switch (stateStruct.status) {
            case BPSExpiredSDK:
                self.setBleStatus(status: "Expired sdk")
                break
            case BPSstartedScan:
                self.setBleStatus(status: "Start Scan")
                break
            case BPSstopedScan:
                self.setBleStatus(status: "Stop Scan")
                break
            case BPSscanFailed:
                // 스캔 요청 했으나 저장된 카드가 없을때 호출 됨
                self.setBleStatus(status: "Failed to Scan")
                break
            case BPSconneting:
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                self.setBleStatus(status: "Connecting")
                break
            case BPSconnetionFail:
                self.setBleStatus(status: "Failed to Connect")
                break
            case BPSconnected:
                self.setBleStatus(status: "Connected")
                break
            case BPSdisconnecting:
                self.setBleStatus(status: "Disconnecting")
                //print("BPSdisconnecting");
                break
            case BPSCardDataSent:
                self.setBleStatus(status: "Send to card data")
                //장치에 카드 데이터 전송
                break
            case BPSdisconnectedByError:
                self.setBleStatus(status: "Disconnected by error")
                self.startScan()
                break
            case BPSdisconnected:
                self.setBleStatus(status: "Disconnected")
                break
            case BPStimeouted:
                self.setBleStatus(status: "Timeout")
                self.startScan()
                break
            case BPSAccessFail:
                // 인증실패 났을 때
                self.setBleStatus(status: "Failed to access")
                break
            case BPSExpiredCredential:
                //  카드 만료 처리
                self.setBleStatus(status: "Expiared credential card")
                break
            default:
                self.setBleStatus(status: "Unknown")
            }
    }
    
    private func checkLocationStatusForBackgroundScan(_ status: CLAuthorizationStatus, accuracy: Int) {
        print("location changed: \(status), \(accuracy)")
        var statusString = ""
        var accuracyString = "On"
        switch (status) {
            case .notDetermined:
                statusString = "Not determined"
               // 사용자가 위치 서비스 권한 설정 팝업에서 아직 선택하지 않은 상태
               // 아래 함수 호출 하면 OS 에서 로케이션 허용 팝업 노출
                SupremaACController.sharedInstance.requestLocationAuthrizationForBackgroundScan()
               break
            case .restricted:
               // 앱 셋팅과 상관 없이 백그라운드 스캔 불가능한 상태
                statusString = "Restircted"
                self.setBackgroundScanToggle(false)
                break
            case .denied:
               // 앱 셋팅과 상관 없이 백그라운드 스캔 불가능한 상태 (아이폰 셋팅 -> 개인 정보 보호 ->  위치 서비스 꺼져 있을때 호출)
                statusString = "Denied"
               self.setBackgroundScanToggle(false)
               break
            case .authorizedAlways:
               // 앱 셋팅과 상관 없이 백그라운드 스캔 가능한 상태
                statusString = "Always"
               //TODO
               break
            case .authorizedWhenInUse:
               // 앱 셋팅과 상관 없이 백그라운드 스캔 불가능한 상태
                statusString = "When in use"
               self.setBackgroundScanToggle(false)
               break
            default:
                statusString = "Unknown"
               break
        }
        if accuracy == ACAccuracyAuthorization.ReducedAccuracy {
            accuracyString = "Off"
        }
        self.setLocationStatus(status: statusString, accuracy: accuracyString)
    }
    
    private func startScan() {
        SupremaACController.sharedInstance.startScan()
    }
    
    private func stopScan() {
        SupremaACController.sharedInstance.stopScan()
    }
    
    private func showMessage(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    /// Stores a credential (base64 JSON issued by the server / AirFob portal) for the given site.
    private func storeCard(siteId: String, credential: String) {
        // Pasted text often carries spaces or line breaks; base64 must be a single clean string.
        let cleaned = credential.components(separatedBy: .whitespacesAndNewlines).joined()

        guard !siteId.isEmpty else {
            self.showMessage("Error", "Site ID is empty.")
            return
        }
        guard let decoded = Data(base64Encoded: cleaned),
              (try? JSONSerialization.jsonObject(with: decoded)) != nil else {
            self.showMessage("Error", "The credential is not valid base64 of a JSON document.")
            return
        }

        let previousSiteId = self.siteId
        let result = ACLocalDataManager.setAcCard(data: cleaned, siteId: siteId)
        print("Result to set card data (site \(siteId)): \(result)")
        guard result else {
            self.showMessage("Error", "The SDK rejected the credential for site \"\(siteId)\".")
            return
        }

        UserDefaults.standard.set(cleaned, forKey: Self.credentialKey)
        self.siteId = siteId
        if siteId != previousSiteId {
            SupremaACController.sharedInstance.initialize(siteId)
        }
        self.startScan()
        self.updateStoredCardLabel()
    }

    @IBAction func addCard(_ sender: Any) {
        let alert = UIAlertController(title: "Add card",
                                      message: "Site ID and credential (base64) issued for this site.",
                                      preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Site ID"
            field.text = self.siteId
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
        }
        alert.addTextField { field in
            field.placeholder = "Credential (base64)"
            field.text = UserDefaults.standard.string(forKey: Self.credentialKey) ?? Self.sampleCredential
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
            field.clearButtonMode = .whileEditing
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            let siteId = (alert.textFields?[0].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let credential = alert.textFields?[1].text ?? ""
            self.storeCard(siteId: siteId, credential: credential)
        })
        self.present(alert, animated: true)
    }

    @IBAction func removeCard(_ sender: Any) {
        ACLocalDataManager.deleteAcCard(self.siteId)
        self.updateStoredCardLabel()
    }
}
