//
//  FmcEnum.h
//  FrejaMobileCore
//
//  Created by Petar Cvetkovic on 6/26/14.
//  Copyright (c) 2014 Verisec Labs. All rights reserved.
//

#ifndef FrejaMobileCore_FmcEnum_h
    #define FrejaMobileCore_FmcEnum_h
#endif

typedef enum {
    TOKEN_USAGE_NOT_SET,
    TOKEN_USAGE_ONLINE,
    TOKEN_USAGE_OFFLINE
} TokenUsage;

typedef enum {
    ERROR_CODE_CONNECTION_FAILED_5003 = 5003,
    ERROR_CODE_NO_INTERNET_5005 = 5005,
    ERROR_CODE_CONNECTION_TIMEOUT_5006 = 5006,
    ERROR_CODE_SSL_CERTIFICATE_PINNING_5007 = 5007,
    ERROR_CODE_SSL_ESTABLISHING_FAILED_5008 = 5008,
    
    ERROR_CODE_MASS_600_URL_NOT_FOUND = 600,                    // INVALID URL OR INVALID JSON
    ERROR_CODE_MASS_1029_UNSUPPORTED_PROTOCOL_VERSIONS = 1029,  // UNSUPPORTED_PROTOCOL_VERSIONS
    
} FmcErrorCode;

typedef enum {
    KEYBOARD_TYPE__NUMERIC = 0,
    KEYBOARD_TYPE__ALPHANUMERIC = 1,
    
    KEYBOARD_TYPE__ONLY_NUMERIC = 2,
    KEYBOARD_TYPE__ONLY_ALPHANUMERIC = 3
    
} KeyboardType;

typedef enum {
    SECURE_MSG = 0,
    TRANSACTION = 1,
    SECURE_TRANSACTION = 2
} TransactionType;

typedef enum {
    NON_APPLICABLE = 0,
    STARTED = 1,
    MOBILE_NOTIFIED = 2,
    DELIVERED_TO_MOBILE = 3,
    EXPIRED = 4,
    CANCELED = 5,
    APPROVED = 6
} TransactionStatus;
