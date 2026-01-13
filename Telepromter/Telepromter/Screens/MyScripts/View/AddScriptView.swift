//
//  AddScriptView.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 06.08.2025.
//

import SwiftUI

struct AddScriptView: View {
	@State private var script: String = ""
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				
				// Заголовок
				HeaderView()
				
				// Разделитель
				DividerLine()
				
				// Поле ввода
				EditorView(script: $script)
				
				Spacer()
				
				// Кнопка
				ContinueButton(script: script)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(
				Image(.darkBkg)
					.resizable()
					.ignoresSafeArea()
			)
		}
	}
}

// MARK: - Header
private struct HeaderView: View {
	@EnvironmentObject var telepromterViewModel: TelepromterViewModel
	
	var body: some View {
		HStack {
			Spacer()
			
			Text("Add Script")
				.foregroundStyle(.white)
				.font(.labelLarge)
				.padding(.leading, 25)
			
			Spacer()
			
			Button {
				telepromterViewModel.isPresentingAddScript.toggle()
			} label: {
				Image(.closeButton)
			}
		}
		.padding(.horizontal)
		.padding(.vertical)
	}
}

// MARK: - Divider
private struct DividerLine: View {
	var body: some View {
		HStack {}
			.frame(width: SizeScreen().width, height: 1)
			.background(Color.divider)
	}
}

// MARK: - Editor
private struct EditorView: View {
	@Binding var script: String
	
	var noEmptyColor: [Color] = [
		Color.white.opacity(0.1),
		Color.white.opacity(0.0)
	]
	
	var emptyColor: [Color] = [
		Color.primaryOrange,
		Color.primaryOrange
	]
	
	var editorBackground: some View {
		RoundedRectangle(cornerRadius: 16)
			.fill(Color.black.opacity(0.35))
			.overlay(
				RoundedRectangle(cornerRadius: 16)
					.stroke(
						LinearGradient(
							gradient: Gradient(colors: script.isEmpty ? emptyColor : noEmptyColor),
							startPoint: .top,
							endPoint: .bottom
						),
						lineWidth: 1
					)
			)
			.shadow(color: Color.white.opacity(0.05), radius: 3, x: 0, y: 1)
	}
	
	var body: some View {
		ZStack(alignment: .topLeading) {
			if script.isEmpty {
				Text("Write your script here...")
					.font(.bodyMedium)
					.foregroundColor(.neutralGrey)
					.padding(.horizontal, 30)
					.padding(.vertical, 14)
					.allowsHitTesting(false) // ⚡️ фикс кликов
			}
			
			TextEditor(text: $script)
				.scrollContentBackground(.hidden)
				.padding(10)
				.foregroundColor(.white)
				.frame(height: 220)
				.background(editorBackground)
				.font(.bodyMedium)
				.padding(.horizontal)
		}
	}
}

// MARK: - Continue Button
private struct ContinueButton: View {
	var script: String
	
	var body: some View {
		ZStack {
			Image(.buttonContainer)
				.resizable()
				.frame(width: SizeScreen().width, height: 90)
			
			if script.isEmpty {
				// Неактивная кнопка
				HStack {
					Spacer()
					
					Text("Continue")
						.font(.bodyMedium)
						.bold()
						.foregroundColor(.white)
					
					Spacer()
					
					Image(.arrowRight)
				}
				.frame(maxWidth: .infinity)
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 20)
						.fill(Color.white.opacity(0.04))
				)
				.overlay(
					RoundedRectangle(cornerRadius: 20)
						.stroke(
							LinearGradient(
								gradient: Gradient(colors: [
									Color.white.opacity(0.2),
									Color.white.opacity(0.05)
								]),
								startPoint: .top,
								endPoint: .bottom
							),
							lineWidth: 1
						)
				)
				.shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
				.cornerRadius(16)
				.padding(.horizontal, 30)
			} else {
				// Активная кнопка
				NavigationLink {
					SelectLayoutView(script: script)
				} label: {
					HStack {
						Spacer()
						
						Text("Continue")
							.font(.bodyMedium)
							.bold()
							.foregroundColor(.white)
							.padding(.leading, 20)
						
						Spacer()
						
						Image(.arrowRight)
					}
					.frame(maxWidth: .infinity)
					.padding()
					.background(
						LinearGradient(
							gradient: Gradient(colors: [
								Color(red: 1, green: 0.39, blue: 0.22),
								Color.primaryOrange
							]),
							startPoint: .leading,
							endPoint: .trailing
						)
					)
					.clipShape(RoundedRectangle(cornerRadius: 16))
					.shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 3)
					.cornerRadius(16)
					.padding(.horizontal, 30)
				}
			}
		}
	}
}

// MARK: - Preview
#Preview {
	AddScriptView()
}
