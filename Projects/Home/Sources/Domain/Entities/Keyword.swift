//
//  Keyword.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/04/05.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

public enum Keyword: Int, CaseIterable {
    case costEffective = 1
    case fall
    case winter
    case ancientWriting
    case fruity
    case anniversary
    case sugary
    case dry
    case holiday
    case noSweetener
    case berry
    case spring
    case ginseng
    case present
    case smallAmount
    case summer
    case pretty
    case unusual
    case lowDegree
    case lowAmount
    case heavyTaste
    case houseWarming
    case cocktail
    case couple
    case others
    case carbonated
    case party
    case solo
    case home

    public var imagePath: String {
        return "https://thesool.com/common/imageView.do?targetId=D000010000" // TODO: 각 키워드에 맞는 사진 찾아서 리소스 파일에 넣기
    }

    public var name: String {
        switch self {
        case .costEffective:
            return "가성비"
        case .fall:
            return "가을"
        case .winter:
            return "겨울"
        case .ancientWriting:
            return "고문헌"
        case .fruity:
            return "과일류"
        case .anniversary:
            return "기념일"
        case .sugary:
            return "달콤"
        case .dry:
            return "드라이"
        case .holiday:
            return "명절"
        case .noSweetener:
            return "무감미료"
        case .berry:
            return "베리류"
        case .spring:
            return "봄"
        case .ginseng:
            return "삼(蔘)류"
        case .present:
            return "선물"
        case .smallAmount:
            return "소용량"
        case .summer:
            return "여름"
        case .pretty:
            return "예쁜술"
        case .unusual:
            return "이색전통주"
        case .lowDegree:
            return "저도수"
        case .lowAmount:
            return "저용량"
        case .heavyTaste:
            return "진한맛"
        case .houseWarming:
            return "집들이"
        case .cocktail:
            return "칵테일"
        case .couple:
            return "커플"
        case .others:
            return "기타"
        case .carbonated:
            return "탄산"
        case .party:
            return "파티"
        case .solo:
            return "혼술"
        case .home:
            return "홈술"
        }
    }

    static func id(of name: String) -> Keyword {
        switch name {
        case "가성비":
            return .costEffective
        case "가을":
            return .fall
        case "겨울":
            return .winter
        case "고문헌":
            return .ancientWriting
        case "과일류":
            return .fruity
        case "기념일":
            return .anniversary
        case "달콤":
            return .sugary
        case "드라이":
            return .dry
        case "명절":
            return .holiday
        case "무감미료":
            return .noSweetener
        case "베리류":
            return .berry
        case "봄":
            return .spring
        case "삼(蔘)류":
            return .ginseng
        case "선물":
            return .present
        case "소용량":
            return .smallAmount
        case "여름":
            return .summer
        case "예쁜술":
            return .pretty
        case "이색전통주":
            return .unusual
        case "저도수":
            return .lowDegree
        case "저용량":
            return .lowAmount
        case "진한맛":
            return .heavyTaste
        case "집들이":
            return .houseWarming
        case "칵테일":
            return .cocktail
        case "커플":
            return .couple
        case "기타":
            return .others
        case "탄산":
            return .carbonated
        case "파티":
            return .party
        case "혼술":
            return .solo
        case "홈술":
            return .home
        default:
            return .others
        }
    }
}
