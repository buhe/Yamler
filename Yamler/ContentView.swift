//
//  ContentView.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/1.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        Text(viewModel.model.yamls.description)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
