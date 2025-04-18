//
//  GenerationView.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import SwiftUI
import GoogleMobileAds

struct GenerationView: View {
    @StateObject private var viewModel: GenerationViewModel
    @State private var dataVersion: String = ""
    @State private var supportYears: [Int] = [1995]
    @State private var selectedYear: Int = 1995
    @State private var showYearPicker: Bool = false // 연도 선택 여부를 관리
    @State private var expandedSections: Set<String> = []
    @State private var isAdLoaded: Bool = false
    
    @ViewBuilder func admob() -> some View {
          // admob
        AdmobBannerView(isAdLoaded: $isAdLoaded, adType: .mainBN).frame(width: AdSizeBanner.size.width, height: AdSizeBanner.size.height)
    }
    
    init() {
        let apiClient = APIClient()
        
        let repository = GenerationRepositoryImpl(apiClient: apiClient)
        let useCase = GenerationUseCaseImpl(generationRepository: repository)
        
        let supportRepository = SupportYearRepositoryImpl(apiClient: apiClient)
        let supportUseCase = SupportUseCaseImpl(supportYearRepository: supportRepository)
        _viewModel = StateObject(wrappedValue: GenerationViewModel(useCase: useCase, supportUseCase: supportUseCase))
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple.opacity(0.7), .blue.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

        
            VStack(spacing: 20) {
                
                // 우측 상단 드롭다운 버튼
                HStack {
                    NavigationLink(destination: ContactView()) {
                        Text("문의하기")
                            .font(.headline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.clear) // 기존 디자인에 맞춘 배경색
                            .cornerRadius(12) // 둥근 모서리
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.7), lineWidth: 1) // 테두리 색상
                            )
                            .foregroundColor(Color.white.opacity(0.7))
                    }
                    .padding(.top)
                    .padding(.leading)
                    Spacer()
                    Button(action: {
                        showYearPicker.toggle() // 드롭다운 표시 여부 토글
                    }) {
                        HStack {
                            Text("\(selectedYear)") // 선택된 연도를 표시
                                .font(.headline)
                                .foregroundColor(Color(uiColor: #colorLiteral(red: 0.4639009833, green: 0.3289078772, blue: 0.7887880206, alpha: 1))) // 기본 텍스트 색상
                            Image(systemName: "chevron.down") // 드롭다운 아이콘
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.clear) // 기존 디자인에 맞춘 배경색
                        .cornerRadius(12) // 둥근 모서리
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.7), lineWidth: 1) // 테두리 색상
                        )
                        .onChange(of: selectedYear) {
                            loadGenerationData()
                        }
                    }
                    .shadow(radius: 5) // 그림자 효과
                    .padding(.top)
                    .padding(.trailing)
                }
                
                VStack {
                    // 연나이와 만나이 표시
                    Text("만 나이: \(viewModel.calculateInternationalAge(from: selectedYear))세 / 연 나이: \(viewModel.calculateKoreanAge(from: selectedYear))세 / \(viewModel.generation?.zodiac ?? "")")
                            .font(.headline)
                            .foregroundColor(.white)
                    if let generation = viewModel.generation {
                        Text("\(generation.generationGroup) / \(generation.generation)")
                                .font(.headline)
                                .foregroundColor(.white)
                    }
                }
                
                if let _ = viewModel.error {
                       // 에러 메시지
                   Text("데이터를 업데이트 할 예정입니다. :)")
                       .foregroundColor(.white)
                       .padding()
                       .background(Color.white.opacity(0.2))
                       .cornerRadius(12)
                       .padding(.horizontal)
                } else {
                    // 데이터 테이블 섹션 뷰
                    ScrollView {
                        if let generation = viewModel.generation {
                            VStack(spacing: 0) {
                                generationSection(title: "특징", content: generation.koreanCharacteristics)
                                    .padding(.bottom, 12)
                                generationSection(title: "기술", content: generation.technology)
                                    .padding(.bottom, 12)
                                generationSection(title: "패션 트렌드", content: generation.fashionTrends)
                                    .padding(.bottom, 12)
                                generationSection(title: "장난감", content: generation.kidsToys)
                                    .padding(.bottom, 12)
                                
                                eventSection(title: "세계 사건", events: generation.worldEvents)
                                    .padding(.bottom, 12)
                                eventSection(title: "한국 사건", events: generation.koreaEvents)
                                    .padding(.bottom, isAdLoaded ? 12 : 6)
                                
                                admob()
                                    .frame(width: 320, height: isAdLoaded ? 50 : 0)
                                    .clipped()
                                    .padding(.bottom, isAdLoaded ? 12 : 6)
                                    .animation(.easeInOut, value: isAdLoaded)
                                
                                musicSection(title: "인기 음악", musics: generation.popularMusic)
                                    .padding(.bottom, 12)
                                dramaSection(title: "인기 드라마", dramas: generation.popularDramas)
                                    .padding(.bottom, 12)
                                movieSection(title: "인기 영화", movies: generation.popularMovies)
                                    .padding(.bottom, 12)
                                animationSection(title: "애니메이션", animations: generation.animation)
                                    .padding(.bottom, 12)
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
                
                if showYearPicker {
                    YearPickerView(selectedYear: $selectedYear, showYearPicker: $showYearPicker, years: supportYears)
                        .background(Color.clear)
                }
                
                // 좌측 하단에 dataVersion 텍스트 표시
                
                HStack {
                    Spacer()
                    Text("Data Version: \(dataVersion)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(.trailing, 16)
                }
                .padding(.top, -10)
                .frame(height: 0)
                .lineLimit(1)
                .truncationMode(.tail)
            }
        }
        .onAppear {
            fetchSupportYears()
            loadGenerationData()
        }
        .onReceive(viewModel.$supportYears) { newSupportYears in
            // ViewModel의 supportYears가 변경되면 해당 배열을 업데이트
            self.supportYears = newSupportYears
        }
        .onReceive(viewModel.$dataVersion) { newDataVersion in
            // ViewModel의 dataVersion이 변경되면 해당 배열을 업데이트
            self.dataVersion = newDataVersion
        }
    }

    private func fetchSupportYears() {
        viewModel.fetchSupportYears()
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
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.event).bold()
                        Text(event.date).font(.caption).foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(12)
                .frame(maxWidth: .infinity) // 셀 너비를 화면에 맞게 확장
            }
        }
    }

    @ViewBuilder
    private func musicSection(title: String, musics: [Music]) -> some View {
        collapsibleSection(title: title) {
            ForEach(musics, id: \ .title) { music in
                HStack(alignment: .top) {
                    if let url = URL(string: music.posterUrl), !music.posterUrl.isEmpty {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 90) // 원하는 크기로 설정
                        .cornerRadius(10)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text(music.title).font(.headline)
                        Text(music.artist).font(.subheadline)
                        Text(music.releaseDate).font(.caption).foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(14)
                .frame(maxWidth: .infinity) // 셀 너비를 화면에 맞게 확장
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
                    .foregroundColor(Color(uiColor: #colorLiteral(red: 0.4639009833, green: 0.3289078772, blue: 0.7887880206, alpha: 1)))
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
