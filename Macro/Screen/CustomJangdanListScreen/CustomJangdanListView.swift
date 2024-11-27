//
//  CustomJangdanListView.swift
//  Macro
//
//  Created by jhon on 11/19/24.
//

import SwiftUI

struct CustomJangdanListView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.editMode) private var editMode
    @Environment(Router.self) var router
    
    @State var viewModel: CustomJangdanListViewModel
    
    var body: some View {
        List {
            if self.viewModel.state.customJangdanList.isEmpty {
                if editMode?.wrappedValue == .inactive {
                    ZStack {
                        EmptyJangdanListView()
                            .padding(.horizontal, 16)
                            .onTapGesture {
                                router.push(.jangdanTypeSelect)
                            }
                    }
                    .buttonStyle(PlainListButton())
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                }
            } else {
                ForEach(self.viewModel.state.customJangdanList, id: \.name) { jangdan in
                    ZStack(alignment: .leading) {
                        ZStack {
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(jangdan.type.name)
                                        .font(.Subheadline_R)
                                        .foregroundStyle(.textSecondary)
                                    
                                    Text(jangdan.name)
                                        .font(.Title3_R)
                                        .foregroundStyle(.textDefault)
                                }
                                
                                Spacer()
                                
                                Text(jangdan.lastUpdate.format("yyyy.MM.dd."))
                                    .font(.Subheadline_R)
                                    .foregroundStyle(.textSecondary)
                            }
                            .offset(x: editMode?.wrappedValue == .active ? 74 : 0) // 삭제 버튼 너비만큼 이동
                            .animation(.easeInOut, value: editMode?.wrappedValue)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 20)
                            .background(.backgroundCard)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                            .padding(.horizontal, 16)
                            .onTapGesture {
                                router.push(.customJangdanPractice(jangdanName: jangdan.name, jangdanType: jangdan.type.rawValue))
                            }
                        }
                        
                        // 삭제버튼 위치(opacity로 조정)
                        Image(systemName: "trash.fill")
                            .font(.system(size: 17))
                            .foregroundStyle(.white)
                            .padding(.vertical, 36)
                            .padding(.horizontal, 25)
                            .background(.red)
                            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 16, bottomLeadingRadius: 16))
                            .padding(.leading, 16)
                            .opacity(editMode?.wrappedValue == .inactive ? 0 : 1)
                            .onTapGesture {
                                self.viewModel.effect(action: .deleteCustomJangdanData(jangdanName: jangdan.name))
                                self.viewModel.effect(action: .fetchCustomJangdanData)
                            }
                    }
                    .buttonStyle(PlainListButton())
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                }
//                .onDelete { indexSet in
//                    guard let index = indexSet.first else { return }
//                    let jangdanName = self.viewModel.state.customJangdanList[index].name
//                    self.viewModel.effect(action: .deleteCustomJangdanData(jangdanName: jangdanName))
//                    self.viewModel.effect(action: .fetchCustomJangdanData)
//                }
            }
        }
        .task {
            self.viewModel.effect(action: .fetchCustomJangdanData)
        }
        .listStyle(.plain)
        .listRowSpacing(12)
        .padding(.top, 32)
        .toolbar {
            // MARK: - 뒤로가기
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.textDefault)
                }
            }
            
            // MARK: - Title
            ToolbarItem(placement: .principal) {
                Text("내가 저장한 장단")
                    .font(.Body_R)
                    .foregroundStyle(.textSecondary)
            }
            
            // MARK: - EditMode
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        self.router.push(.jangdanTypeSelect)
                    } label: {
                        Image(systemName: "plus")
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.textDefault)
                    }

                    EditButton()
                        .foregroundStyle(.textDefault)
                }
            }
        }
        .toolbarBackground(.backgroundNavigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

extension CustomJangdanListView {
    private struct PlainListButton: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .animation(nil, value: configuration.isPressed)
        }
    }
}
