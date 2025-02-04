//
//  This file is part of the 2FAS iOS app (https://github.com/twofas/2fas-ios)
//  Copyright © 2023 Two Factor Authentication Service, Inc.
//  Contributed by Zbigniew Cisiński. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <https://www.gnu.org/licenses/>
//

import Foundation

final class MainTabPresenter {
    weak var view: MainTabViewControlling?
    
    private var previousSelectedViewPath: ViewPath?
    private let flowController: MainTabFlowControlling
    private var isViewLoaded = false
    
    init(flowController: MainTabFlowControlling) {
        self.flowController = flowController
    }
}

extension MainTabPresenter {
    func viewWillAppear() {
        isViewLoaded = true
        flowController.toTabIsReady()
    }
    
    func handleDidSelectViewPath(_ viewPath: ViewPath) {
        if previousSelectedViewPath != viewPath {
            flowController.toMainChangedViewPath(viewPath)
            handleChangeViewPath(viewPath)
        } else {
            switch viewPath {
            case .main:
                view?.scrollToTokensTop()
            case .settings:
                view?.setSettingsView(nil)
                previousSelectedViewPath = .settings(option: nil)
            }
        }
    }
    
    func handleChangeViewPath(_ viewPath: ViewPath) {
        guard viewPath != previousSelectedViewPath, isViewLoaded else { return }
        view?.setView(viewPath)
        switch viewPath {
        case .main:
            flowController.tokensSwitchToTokensTab()
        case .settings(let option):
            view?.setSettingsView(option)
        }
        previousSelectedViewPath = viewPath
    }
    
    func handleSettingsChangedViewPath(_ viewPath: ViewPath.Settings?) {
        previousSelectedViewPath = .settings(option: viewPath)
    }
    
    func resetViewPath() {
        previousSelectedViewPath = nil
    }
}
