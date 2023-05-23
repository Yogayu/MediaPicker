//
//  AlbumSelectionView.swift
//  
//
//  Created by Alisa Mylnikova on 08.02.2023.
//

import SwiftUI

public struct AlbumSelectionView: View {

    @ObservedObject var viewModel: MediaPickerViewModel

    @Binding var showingCamera: Bool
    let showingLiveCameraCell: Bool
    let selectionParamsHolder: SelectionParamsHolder
    let filterClosure: MediaPicker.FilterClosure?
    let massFilterClosure: MediaPicker.MassFilterClosure?

    @State private var showingLoadingCell = false

    public var body: some View {
        switch viewModel.internalPickerMode {
        case .photos:
            AlbumView(
                viewModel: AlbumViewModel(
                    mediasProvider: AllPhotosProvider(selectionParamsHolder: selectionParamsHolder, filterClosure: filterClosure, massFilterClosure: massFilterClosure, showingLoadingCell: $showingLoadingCell)
                ),
                showingCamera: $showingCamera,
                shouldShowCamera: showingLiveCameraCell,
                shouldShowLoadingCell: showingLoadingCell,
                selectionParamsHolder: selectionParamsHolder
            )
        case .albums:
            AlbumsView(
                viewModel: AlbumsViewModel(
                    albumsProvider: viewModel.defaultAlbumsProvider
                ),
                showingCamera: $showingCamera,
                selectionParamsHolder: selectionParamsHolder,
                filterClosure: filterClosure,
                massFilterClosure: massFilterClosure
            )
            .onAppear {
                viewModel.defaultAlbumsProvider.mediaSelectionType = selectionParamsHolder.mediaType
            }
        case .album(let album):
            if let albumModel = viewModel.getAlbumModel(album) {
                AlbumView(
                    viewModel: AlbumViewModel(
                        mediasProvider: AlbumMediasProvider(album: albumModel, selectionParamsHolder: selectionParamsHolder, filterClosure: filterClosure, massFilterClosure: massFilterClosure, showingLoadingCell: $showingLoadingCell)
                    ),
                    showingCamera: $showingCamera,
                    shouldShowCamera: false,
                    shouldShowLoadingCell: showingLoadingCell,
                    selectionParamsHolder: selectionParamsHolder
                )
                .id(album.id)
            }
        default:
            EmptyView()
        }
    }
}

public struct ModeSwitcher: View {

    @Binding var selection: Int

    public var body: some View {
        Picker("", selection: $selection) {
            Text("Photos")
                .tag(0)
            Text("Albums")
                .tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(maxWidth: UIScreen.main.bounds.width / 2)
    }
}
