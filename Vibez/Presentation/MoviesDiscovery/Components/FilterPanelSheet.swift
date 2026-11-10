import SwiftUI

struct FilterPanelSheet: View {
    @Binding var filters: MovieFilters
    @Environment(\.dismiss) private var dismiss
    var resetFilters: () -> Void
    var fetchFilteredMovies: (Bool) async -> Void

    private var originCountryBinding: Binding<MovieFilters.MovieCountry> {
        Binding(
            get: { filters.withOriginCountry ?? .all},
            set: { filters.withOriginCountry = $0 == .all ? nil : $0 }
        )
    }

    private var displayLanguageBinding: Binding<MovieFilters.MovieLanguage> {
        Binding(
            get: { filters.language ?? .all},
            set: { filters.language = $0 == .all ? nil : $0 }
        )
    }

    private var originLanguageBinding: Binding<MovieFilters.MovieLanguage> {
        Binding(
            get: { filters.withOriginalLanguage ?? .all},
            set: { filters.withOriginalLanguage = $0 == .all ? nil : $0 }
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Sort") {
                    Picker("SortBy", selection: $filters.sortBy) {
                        ForEach(MovieFilters.SortBy.allCases) { sort in
                            Text(sort.displayName).tag(sort)
                        }
                    }
                }

                Section("Minimum Rating") {
                    HStack {
                        Slider(
                            value: Binding(
                                get: { filters.voteAverageGte ?? 1.0 },
                                set: { filters.voteAverageGte = $0 == 1.0 ? nil : $0 }
                            ),
                            in: 1...10,
                            step: 0.5
                        )
                        Text(String(format: "%.1f ★", filters.voteAverageGte ?? 0.0 ))
                            .monospacedDigit()
                    }
                }

                Section("Country and language") {
                    Picker("Origin Country", selection: originCountryBinding) {
                        ForEach(MovieFilters.MovieCountry.allCases) { country in
                            Text(country.displayName).tag(country)
                        }
                    }

                    Picker("Display Language", selection: displayLanguageBinding) {
                        ForEach(MovieFilters.MovieLanguage.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    }

                    Picker("Origin Language", selection: originLanguageBinding) {
                        ForEach(MovieFilters.MovieLanguage.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                }

            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset") {
                        resetFilters()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Apply") {
                        Task {
                            await fetchFilteredMovies(false)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
