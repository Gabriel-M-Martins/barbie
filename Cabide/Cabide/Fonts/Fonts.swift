//
//  Fonts.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 08/08/23.
//

import Foundation
import UIKit

class CustomFonts {
    let Montserrat: String = "Montserrat"
    let MontserratRomanRegular: String = "MontserratRoman-Regular"
    let MontserratThin: String = "Montserrat-Thin"
    let MontserratRomanExtraLight: String = "MontserratRoman-ExtraLight"
    let MontserratRomanLight: String = "MontserratRoman-Light"
    let MontserratRomanMedium: String = "MontserratRoman-Medium"
    let MontserratRomanSemiBold: String = "MontserratRoman-SemiBold"
    let MontserratRomanBold: String = "MontserratRoman-Bold"
    let MontserratRomanExtraBold: String = "MontserratRoman-ExtraBold"
    let MontserratRomanBlack: String = "MontserratRoman-Black"
    
    var customFontLabel: UIFont = UIFont()
    var customFontTitle: UIFont = UIFont()
    
    init() {
        guard let customFont = UIFont(name: MontserratRomanMedium, size: 18) else {
            fatalError("""
                Failed to load the custom font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        self.customFontLabel = customFont
        
        guard let customFont = UIFont(name: MontserratRomanSemiBold, size: 24) else {
            fatalError("""
                Failed to load the custom font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        self.customFontTitle = customFont
    }
    
}
