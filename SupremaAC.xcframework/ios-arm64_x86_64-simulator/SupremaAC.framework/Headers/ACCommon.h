/*
* Copyright 2019. Moca System Inc. All Rights Reserved.
*
* This software is the confidential and proprietary information of Moca System Inc. ("Confidential Information").
* You shall not disclose such Confidential Information and shall use it only in accordance with the
* terms of the license agreement you entered into with Suprema.
*/

//
//  ACCommon.h
//  SupremaAC
//
//  Created by Jeonjongmin on 2019/12/11.
//  Copyright © 2019 Jeonjongmin. All rights reserved.
//

#ifndef ACCommon_h
#define ACCommon_h
 
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

typedef enum{
    /*! Get mothod */
    GET,
    /*! Post method */
    POST,
    /*! Put method */
    PUT,
    /*! Delete method */
    DELETE
} MethodType;

typedef enum {
    Ascending = 0,
    Descending
} SortType;

typedef enum {
    BPSExpiredSDK = -1,
    BPSstartedScan = 0,
    BPSstopedScan,
    BPSscanFailed,
    BPSconneting,
    BPSconnetionFail,
    BPSconnected,
    BPSdisconnecting,
    BPSCardDataSent,
    BPSdisconnectedByError,
    BPSdisconnected,
    BPStimeouted,
    BPSAccessSuccess,
    BPSAccessFail,
    BPSExpiredCredential,
} BLEProcessStatus;

typedef enum {
    SensitivityTight = 0,
    SensitivityNormal,
    SensitivityLong
} BLESensitivity;

typedef enum {
    // activate
    FailedReasonCardStatus = 0,
    // firmware result
    SharedKeyError = 2,
    ReadLengthZeroError,
    CardEncryptionTypeError,
    OTPError,
    CardDataError,
    DeviceKeyError,
    VerifyError,
    Base64DecodeError,
    CardNumberError,
    NFCError,
    TimeoutError,
    // access
    NetworkDisconnected = 813,
    NotExistsAccessLevel,
    Holiday,
    NotAccessibleTime,
    FailedGetDBManager,
    NotRegisterDevice,
    NotAccessiblePeriod,
} AccessFailCode;

typedef struct __attribute__((packed)) {
    BLEProcessStatus status;
    /*
     * It is meaningful when BLEProcessStatus is BPSCardDataSent. 0 means no type, 1 to 255 type will be different depending on the definition in the site.
     * BLEProcessStatus is fixed to 0 when the value is other than BPSCardDataSent.
     */
    NSInteger deviceType;
    NSInteger code;
} BLEProcessStruct;

typedef enum {
    FullAccuracy = 0,
    ReducedAccuracy
} AccuracyAuthorization;

typedef enum {
    CardGenerated = 0,
    CardStatusUpdated,
    UserInfoUpdated,
    AccessLevelUpdated,
    Tagging,
    Crash,
    CardRemove = 7
} BugReportType;

#endif /* ACCommon_h */
