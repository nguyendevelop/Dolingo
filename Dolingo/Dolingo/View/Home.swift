//
//  Home.swift
//  Dolingo
//
//  Created by Nguyen Dang Quy on 28/03/2022.
//

import SwiftUI

struct Home: View {
    //Properties
    @State var progress: CGFloat = 0
    @State var characters: [Character] = characters_
    
    //Custom Grid Arrays
    //for Drag
    @State var shuffledRows: [[Character]] = []
    //for Drop
    @State var rows: [[Character]] = []
    
    var body: some View {
        VStack(spacing: 15) {
            NavBar()
            
            VStack(alignment: .leading, spacing: 30) {
                Text("Form this sentence")
                    .font(.title2.bold())
                
                Image("Character")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing,100)
                
                
                
            }
            .padding(.top,30)
            
            //Mark: Drag drop area
            DropArea()
                .padding(.vertical,30)
            DragArea()
            
        }
        .padding()
        .onAppear {
            if rows.isEmpty {
                //crating shuffled one
                //then normail one
                characters = characters.shuffled()
                shuffledRows = generateGrid()
                characters = characters_
                rows = generateGrid()
            }
        }
    }
    
    @ViewBuilder
    func DropArea()->some View{
        VStack(spacing: 12) {
            ForEach($rows, id: \.self) { $row in
                HStack(spacing: 10) {
                    ForEach($row) { $item in
                        
                        Text(item.value)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical,5)
                            .padding(.horizontal,item.padding)
                        //hidden
                            .opacity(item.isShowing ? 1 : 0)
                            .background{
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(item.isShowing ? .clear : .gray.opacity(0.25))
                            }
                        background {
                            //if item is dropped into correct place
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .stroke(.gray)
                                .opacity(item.isShowing ? 1 : 0)
                        }
                        //Adding drop operation
                        .onDrop(of: [.url], isTargeted: .constant(false)) {
                            providers in
                            
                            if let first = providers.first {
                                let _ = first.loadObject(ofClass: URL.self) {
                                    value,error in
                                    
                                    guard let url = value else{return}
                                    //print(url)
                                    if item.id == "\(url)" {
                                        item.isShowing = true
                                    }
                                }
                            }
                            
                            return false
                        }
                    }
                }
                
                if rows.last != row {
                    Divider()
                }
            }
        }
    }
    
    @ViewBuilder
    func DragArea()->some View{
        VStack(spacing: 12) {
            ForEach(shuffledRows, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row) { item in
                        
                        Text(item.value)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical,5)
                            .padding(.horizontal,item.padding)
                            .background{
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.gray)
                            }
                        //Adding drag oparation
                            .onDrag {
                                //returning ID to find which item is Moving
                                return .init(contentsOf: URL(string: item.id))!
                            }
                            .opacity(item.isShowing ? 1 : 0)
                            .background{
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(item.isShowing ? .gray.opacity(0.25) : .clear)
                            }
                    }
                }
                
                if shuffledRows.last != row {
                    Divider()
                }
            }
        }
    }
    
    //custom Nav Bar
    @ViewBuilder
    func NavBar()-> some View {
        HStack(spacing: 18) {
            Button {
                
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.gray.opacity(0.25))
                    
                    Capsule()
                        .fill(Color("Green"))
                        .frame(width: proxy.size.width * progress)
                }
            }
            .frame(height: 20)
            
            Button {
                
            } label: {
                Image(systemName: "suit.heart.fill")
                    .font(.title3)
                    .foregroundColor(.red)
            }
        }
    }
    
    //Generating custom grid comlumns
    func generateGrid()->[[Character]] {
        
        for item in characters.enumerated() {
            let textSize = textSize(character: item.element)
            
            characters[item.offset].textSize = textSize
        }
        
        var gridArray: [[Character]] = []
        var tempArray: [Character] = []
        
        //current width
        var currentWidth: CGFloat = 0
        
        let totalScreenWidth: CGFloat = UIScreen.main.bounds.width - 30
        
        for character in characters {
            currentWidth += character.textSize
            
            if currentWidth < totalScreenWidth {
                tempArray.append(character)
            } else {
                gridArray.append(tempArray)
                tempArray = []
                currentWidth = character.textSize
                tempArray.append(character)
            }
        }
        
        //Checking Exhaust
        if !tempArray.isEmpty {
            gridArray.append(tempArray)
        }
        
        return gridArray
    }
    
    //Identifying text size
    func textSize(character: Character)->CGFloat {
        let font = UIFont.systemFont(ofSize: character.fontSize)
        
        let attributes = [NSAttributedString.Key.font : font]
        
        let size = (character.value as NSString).size(withAttributes: attributes)
        
        //horizontal padding
        //return size.width * (character.padding * 2)
        //Adding HStack Spacing
        return size.width + (character.padding * 2) + 15
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
