//
//  PromptsView.swift
//  yournal
//
//  Created by Patrick Johnson on 4/2/21.
//

import SwiftUI

struct PromptsView: View {
    @ObservedObject var promptViewModel = PromptViewModel()
    @State var showNewPromptSheet = false
    @State var newPrompt = ""
    init() {
       UITableView.appearance().backgroundColor = UIColor(Color("Background"))
    }
    var body: some View {
        ZStack{
            Background()
            List{
                if(showNewPromptSheet){
                    TextField("Describe your day...", text: $newPrompt).listRowBackground(Color("Background"))
                }
                ForEach(promptViewModel.prompts.indices, id: \.self){ index in
                    Text(promptViewModel.prompts[index].value!)
                }
                .onDelete(perform: deletePrompt)
                .listRowBackground(Color("Background"))
            }
        }
        .onAppear(perform: {
            promptViewModel.loadPrompts()
        })
        .navigationTitle("Prompts")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {actionPressed()}, label: {
                    if(showNewPromptSheet){
                        Image(systemName: "checkmark")
                    }else{
                        Image(systemName: "plus")
                    }
                    
                })
            })
        })
    }
    
    func actionPressed(){
        if(showNewPromptSheet && newPrompt != ""){
            promptViewModel.addPrompt(value: newPrompt)
        }
        showNewPromptSheet.toggle()
    }
    
    func deletePrompt(at offset: IndexSet){
        promptViewModel.delete(prompt: promptViewModel.prompts[offset.first!])
    }
}

struct PromptsView_Previews: PreviewProvider {
    static var previews: some View {
        PromptsView()
    }
}
