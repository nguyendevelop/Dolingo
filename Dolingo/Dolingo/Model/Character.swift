//
//  Character.swift
//  Dolingo
//
//  Created by Nguyen Dang Quy on 28/03/2022.
//

import SwiftUI

struct Character: Identifiable,Hashable,Equatable {
    var id = UUID().uuidString
    var value: String
    var padding: CGFloat = 10
    var textSize: CGFloat = .zero
    var fontSize: CGFloat = 19
    var isShowing: Bool = false
}

var characters_: [Character] = [

    Character(value: "私"),
    Character(value: "は"),
    Character(value: "ベトナム"),
    Character(value: "から"),
    Character(value: "来ました"),
]
