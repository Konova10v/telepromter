//
//  Font.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 04.08.2025.
//

import SwiftUI

extension Font {
	
	// MARK: - Headings
	static var h1: Font { .system(size: 60, weight: .bold, design: .default) }
	static var h2: Font { .system(size: 48, weight: .bold, design: .default) }
	static var h3: Font { .system(size: 40, weight: .semibold, design: .default) }
	static var h4: Font { .system(size: 32, weight: .semibold, design: .default) }
	static var pretitle: Font { .system(size: 13, weight: .medium, design: .default) }

	// MARK: - Labels
	static var labelXLarge: Font { .system(size: 20, weight: .medium, design: .default) }
	static var labelLarge: Font { .system(size: 18, weight: .medium, design: .default) }
	static var labelMedium: Font { .system(size: 16, weight: .medium, design: .default) }
	static var labelSmall: Font { .system(size: 14, weight: .medium, design: .default) }
	static var labelXSmall: Font { .system(size: 12, weight: .medium, design: .default) }
	
	// MARK: - Body
	static var bodyXLarge: Font { .system(size: 18, weight: .regular, design: .default) }
	static var bodyLarge: Font { .system(size: 18, weight: .regular, design: .default) }
	static var bodyMedium: Font { .system(size: 16, weight: .regular, design: .default) }
	static var bodySmall: Font { .system(size: 14, weight: .regular, design: .default) }
	static var bodyXSmall: Font { .system(size: 12, weight: .regular, design: .default) }
}
