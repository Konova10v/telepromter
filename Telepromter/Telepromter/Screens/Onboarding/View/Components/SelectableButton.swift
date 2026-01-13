//
//  SelectableButton.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 04.08.2025.
//

import SwiftUI

struct SelectableButton: View {
	var title: String
	var systemIcon: Image
	@Binding var isSelected: Bool
	var count: Int
	var action: () -> Void
	
	var body: some View {
		Button(action: action) {
			HStack(spacing: 10) {
				systemIcon
					.resizable()
					.frame(width: 24, height: 24)
				
				Text(title)
					.font(.system(size: 18, weight: .medium))
					.foregroundColor(.white)
				
				Spacer()
				
				Image(isSelected ? .planSelectorOn : .planSelectorOff)
			}
			.padding(.horizontal)
			.padding(.vertical, count == 4 ? 14 : 16)
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(
				RoundedRectangle(cornerRadius: 14)
					.fill(isSelected ? Color.primaryOrange.opacity(0.12) : Color.white.opacity(0.04))
			)
			.overlay(
				RoundedRectangle(cornerRadius: 14)
					.stroke(
						LinearGradient(
							gradient: Gradient(colors: isSelected ? [
								Color.primaryOrange, Color.primaryOrange
							] : [
								Color.white.opacity(0.2), Color.white.opacity(0.0)
							]),
							startPoint: .top,
							endPoint: .bottom
						),
						lineWidth: 1
					)
			)
			.shadow(color: Color(red: 0.07, green: 0.07, blue: 0.07).opacity(1.0),
					radius: 0, x: 0, y: 0)
			.shadow(color: Color(red: 0.07, green: 0.07, blue: 0.07).opacity(0.5),
					radius: 2, x: 0, y: 1)
		}
		.buttonStyle(PlainButtonStyle())
	}
}
