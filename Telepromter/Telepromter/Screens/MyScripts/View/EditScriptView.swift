//
//  EditScriptView.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 06.08.2025.
//

import SwiftUI

struct EditScriptView: View {
	@EnvironmentObject var viewModel: TelepromterViewModel
	@StateObject private var recordingViewModel = RecordingViewModel()
	@State var title: String
	@State var script: String
	@State var entity: RecordingEntity
	
    var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Spacer()
				
				Text("Edit Script")
					.foregroundStyle(.white)
					.font(.labelLarge)
					.padding(.leading, 25)
				
				Spacer()
				
				Button {
					viewModel.editScript.toggle()
				} label: {
					Image(.closeButton)
				}
			}
			.padding(.horizontal)
			.padding(.vertical)
			
			HStack {}
				.frame(width: SizeScreen().width, height: 1)
				.background(Color.divider)
			
			VStack(alignment: .leading, spacing: 30) {
				VStack(alignment: .leading, spacing: 15) {
					Text("Title")
						.foregroundStyle(.white)
						.font(.labelLarge)
					
					TextField("", text: $title)
						.padding()
						.foregroundColor(.white)
						.background(
							RoundedRectangle(cornerRadius: 22)
								.fill(Color.black.opacity(0.35))
								.overlay(
									RoundedRectangle(cornerRadius: 22)
										.stroke(
											LinearGradient(
												gradient: Gradient(colors: [
													Color.white.opacity(0.1),
													Color.white.opacity(0.0)
												]),
												startPoint: .top,
												endPoint: .bottom
											),
											lineWidth: 1
										)
								)
								.shadow(color: Color.white.opacity(0.05), radius: 3, x: 0, y: 1)
						)
						.font(.bodyMedium)
						.multilineTextAlignment(.leading)
				}
				
				VStack(alignment: .leading, spacing: 15) {
					Text("Script")
						.foregroundStyle(.white)
						.font(.labelLarge)
					
					TextEditor(text: $script)
						.scrollContentBackground(.hidden)
						.padding(10)
						.foregroundColor(.white)
						.frame(height: 220)
						.background(
							RoundedRectangle(cornerRadius: 16)
								.fill(Color.black.opacity(0.35))
								.overlay(
									RoundedRectangle(cornerRadius: 16)
										.stroke(
											LinearGradient(
												gradient: Gradient(colors: [
													Color.white.opacity(0.1),
													Color.white.opacity(0.0)
												]),
												startPoint: .top,
												endPoint: .bottom
											),
											lineWidth: 1
										)
									)
								.shadow(color: Color.white.opacity(0.05), radius: 3, x: 0, y: 1)
						)
						.font(.bodyMedium)
				}
			}
			.padding(.horizontal)
			.padding(.vertical)
			
			Spacer()
			
			ZStack {
				Image(.buttonContainer)
					.resizable()
					.frame(width: SizeScreen().width, height: 90)
				
				Button(action: {
					recordingViewModel.updateRecording(entity, newScript: script, newCreatedAt: title)
					
					viewModel.editScript.toggle()
				}) {
					HStack {
						Spacer()
						
						Text("Save")
							.font(.bodyMedium)
							.bold()
							.foregroundColor(.white)
							.padding(.leading, 20)
						
						Spacer()
						
						Image(.save)
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
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(
			Image(.darkBkg)
				.resizable()
				.ignoresSafeArea()
		)
    }
}
