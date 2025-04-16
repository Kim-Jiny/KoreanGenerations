//
//  GenerationView.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import SwiftUI

struct GenerationView: View {
    @StateObject private var viewModel: GenerationViewModel
    @State private var selectedYear: Int = 1995
    @State private var expandedSections: Set<String> = []
    
    init() {
        let repository = GenerationRepositoryImpl(apiClient: APIClient())
        let useCase = GenerationUseCaseImpl(generationRepository: repository)
        _viewModel = StateObject(wrappedValue: GenerationViewModel(useCase: useCase))
    }
    
    let allYears = Array(1900...2025)

    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple.opacity(0.7), .blue.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // 상단 년도 선택
                VStack(spacing: 8) {
                    Text("세대별 정보 보기")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)

                    Picker("년도 선택", selection: $selectedYear) {
                        ForEach(allYears, id: \ .self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 100)
                    .clipped()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .onChange(of: selectedYear) { _ in
                        loadGenerationData()
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding(.top)

                VStack {
                    // 연나이와 만나이 표시
                    Text("만 나이: \(viewModel.calculateInternationalAge(from: selectedYear))세 / 연 나이: \(viewModel.calculateKoreanAge(from: selectedYear))세")
                            .font(.headline)
                            .foregroundColor(.white)
                    if let generation = viewModel.generation {
                        Text("\(generation.generationGroup) / \(generation.generation)")
                                .font(.headline)
                                .foregroundColor(.white)
                    }
                    
                }
                
                if let error = viewModel.error {
                       // 에러 메시지
                       Text("⚠️ 오류 발생: \(error.localizedDescription)")
                           .foregroundColor(.red)
                           .padding()
                           .background(Color.white.opacity(0.2))
                           .cornerRadius(12)
                           .padding(.horizontal)
                } else {
                    // 데이터 테이블 섹션 뷰
                    ScrollView {
                        
                        if viewModel.isLoading {
                            ProgressView("데이터 불러오는 중...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding()
                        }
                        
                        if let generation = viewModel.generation {
                            VStack(spacing: 12) {
                                generationSection(title: "특징", content: generation.koreanCharacteristics)
                                generationSection(title: "기술", content: generation.technology)
                                generationSection(title: "패션 트렌드", content: generation.fashionTrends)
                                generationSection(title: "장난감", content: generation.kidsToys)
                                
                                eventSection(title: "세계 사건", events: generation.worldEvents)
                                eventSection(title: "한국 사건", events: generation.koreaEvents)
                                
                                musicSection(title: "인기 음악", musics: generation.popularMusic)
                                dramaSection(title: "인기 드라마", dramas: generation.popularDramas)
                                movieSection(title: "인기 영화", movies: generation.popularMovies)
                                animationSection(title: "애니메이션", animations: generation.animation)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 100)
                        } else if viewModel.isLoading {
                            ProgressView("데이터 불러오는 중...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding()
                        } else if let error = viewModel.error {
                            Text("Error: \(error.localizedDescription)")
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                }
            }
        }
        .onAppear {
            loadGenerationData()
        }
    }

    private func loadGenerationData() {
        viewModel.loadGenerationData(for: selectedYear)
    }

    @ViewBuilder
    private func generationSection(title: String, content: [String]) -> some View {
        collapsibleSection(title: title) {
            ForEach(content, id: \ .self) { item in
                Text("• \(item)")
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
            }
        }
    }

    @ViewBuilder
    private func eventSection(title: String, events: [Event]) -> some View {
        collapsibleSection(title: title) {
            ForEach(events, id: \ .event) { event in
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.event).bold()
                    Text(event.date).font(.caption).foregroundColor(.gray)
                }
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(12)
            }
        }
    }

    @ViewBuilder
    private func musicSection(title: String, musics: [Music]) -> some View {
        collapsibleSection(title: title) {
            ForEach(musics, id: \ .title) { music in
                VStack(alignment: .leading, spacing: 6) {
                    Text(music.title).font(.headline)
                    Text(music.artist).font(.subheadline)
                    Text(music.releaseDate).font(.caption).foregroundColor(.gray)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(14)
            }
        }
    }

    @ViewBuilder
    private func dramaSection(title: String, dramas: [Drama]) -> some View {
        collapsibleSection(title: title) {
            ForEach(dramas, id: \ .title) { drama in
                HStack(alignment: .top) {
                    if let url = URL(string: drama.posterUrl), !drama.posterUrl.isEmpty {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 90) // 원하는 크기로 설정
                        .cornerRadius(10)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(drama.title).font(.headline)
                        Text("방송: \(drama.broadcastNetwork)")
                        Text("\(drama.startDate) ~ \(drama.endDate)").font(.caption).foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(12)
                .frame(maxWidth: .infinity)
            }
        }
    }

    @ViewBuilder
    private func movieSection(title: String, movies: [Movie]) -> some View {
        collapsibleSection(title: title) {
            ForEach(movies, id: \.krTitle) { movie in
                HStack(alignment: .top) {
                    if let url = URL(string: movie.posterUrl), !movie.posterUrl.isEmpty {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 90) // 원하는 크기로 설정
                        .cornerRadius(10)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(movie.krTitle).bold()
                        Text(movie.enTitle)
                        Text("출시일: \(movie.releaseDate)").font(.caption).foregroundColor(.gray)
                    }
                    Spacer() // 화면 크기에 맞춰 나머지 공간을 채움
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .frame(maxWidth: .infinity) // 셀 너비를 화면에 맞게 확장
            }
        }
    }

    @ViewBuilder
    private func animationSection(title: String, animations: [Animation]) -> some View {
        collapsibleSection(title: title) {
            ForEach(animations, id: \ .title) { animation in
                HStack(alignment: .top) {
                    if let url = URL(string: animation.posterUrl), !animation.posterUrl.isEmpty {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 80, height: 120)
                        .cornerRadius(10)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(animation.title).bold()
                        Text("\(animation.startDate) ~ \(animation.endDate)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer() // 화면 크기에 맞춰 나머지 공간을 채움
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
                .frame(maxWidth: .infinity) // 셀 너비를 화면에 맞게 확장
            }
        }
    }

    @ViewBuilder
    private func collapsibleSection<Content: View>(title: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    if expandedSections.contains(title) {
                        expandedSections.remove(title)
                    } else {
                        expandedSections.insert(title)
                    }
                }) {
                    Image(systemName: expandedSections.contains(title) ? "chevron.down" : "chevron.right")
                        .foregroundColor(.white)
                        .imageScale(.medium)
                        .padding(.trailing, 8)
                }
            }
            .padding(.horizontal)

            if expandedSections.contains(title) {
                content()
            }
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(20)
        .shadow(radius: 4)
    }

}

//#Preview {
//    GenerationView()
//}
