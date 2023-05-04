//
//  LiquorChannel.swift
//  BaseDomain
//
//  Created by 천수현 on 2023/05/04.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

public enum LiquorChannel {
    case drinkHouse
    case juryuhak
    case alcoholCanyon

    public var channelId: String {
        switch self {
        case .drinkHouse:
            return "UCR93_qwfgePfdrJVyqYvVCg"
        case .juryuhak:
            return "UCB9wEdhMy5Mi8SLNBD-tUrQ"
        case .alcoholCanyon:
            return "UCW6b_7bRtVUC5uinBsFfU1g"
        }
    }

    public var name: String {
        switch self {
        case .drinkHouse:
            return "술익는집"
        case .juryuhak:
            return "주류학개론"
        case .alcoholCanyon:
            return "알콜의협곡"
        }
    }
}
