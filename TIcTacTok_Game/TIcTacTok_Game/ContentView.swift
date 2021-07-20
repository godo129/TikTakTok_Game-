//
//  ContentView.swift
//  TIcTacTok_Game
//
//  Created by hong on 2021/07/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView {
            Home()
                .navigationTitle("Tic Tac Toe")
                .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    //Moves...
    @State var moves : [String] = Array(repeating: "", count: 9)
    // 현재 플레이어 구분
    @State var isPlaying = false
    @State var gameOver = false
    @State var msg = ""
    
    var body: some View{
        
        VStack{
            
            // GridView 플레이하기 위한
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                
                ForEach(0..<9, id: \.self){ index in
                    
                    ZStack {
                        
                        // Flip Animation
                        
                        Color.blue
                        
                        Color.white
                            .opacity(moves[index] == "" ? 1 : 0)
                        
                        Text(moves[index])
                            .font(.system(size: 55, weight: .heavy))
                            .foregroundColor(.white)
                            .opacity(moves[index] == "" ? 0 : 1)
                                   
                            
                    }
                    .frame(width: getWidth(), height: getWidth())
                    .cornerRadius(15)
                    // 눌릴때마다 move에 추가
                    .rotation3DEffect(.init(degrees: moves[index] != "" ? 180 : 0),
                                      axis: (x: 0.0, y: 1.0, z: 0.0),
                                      anchor: .center, anchorZ: 0.0,
                                      perspective: 1.0
                    )
                    
                    .onTapGesture (perform: {
                        withAnimation(Animation.easeIn(duration: 0.5)){
                            
                            if moves[index] == "" {
                                moves[index] = isPlaying ? "X" : "O"
                                // 플레이어 갱신
                                isPlaying.toggle()
                                
                            }
                        }
                    })
  
                }
            }
            .padding(15)
        }
        // 매 움직임마다 승리자 찾기
        .onChange(of: moves, perform:  { value in
            checkWinner()
        })
        .alert(isPresented: $gameOver) {
            Alert(title: Text("Winner"), message: Text(msg), dismissButton: .destructive(Text("Play Again"), action: {
                
                // 데이터 원래형태로 복구
                withAnimation(Animation.easeIn(duration: 0.5)) {
                    moves.removeAll()
                    moves = Array(repeating: "", count: 9)
                    isPlaying = true
                }
            }))
        }
    }
    
    // 가로 계산
    
    func getWidth() -> CGFloat {
        
        // Horizontal padding = 30
        // spacing = 30
        
        let width = UIScreen.main.bounds.width - (30 + 30)
        
        return width / 3
    }
    
    // checking for winner ...
    
    func checkWinner() {
        
        if checkMoves(player: "X") {
            // 알림 뷰
            
            msg = "player X won !!!"
            gameOver.toggle()
            
        }
        
        else if checkMoves(player: "O") {
            
            msg = "Player O won !!!"
            gameOver.toggle()
            
        }
        else {
            
            let status = moves.contains { (Value) -> Bool in
                
                return Value == ""
            }
            
            if !status {
                msg = "Game Over Tied !!!"
                gameOver.toggle()
            
        }
        
    }
}
    
    func checkMoves (player: String) -> Bool {
        
        // 수평 체크
        
        for i in stride(from: 0, to: 9, by: 3) {
            if moves[i] == player && moves[i+1] == player && moves[i+2] == player {
                
                return true
            }
        }
        
        // 수직 체크
        for i in 0...2 {
            if moves[i] == player && moves[i+3] == player && moves[i+6] == player {
                
                return true
            }
        }
        
        // 대각선 체크
        if moves[0] == player && moves[4] == player && moves[8] == player {
            
            return true
        }
        
        
        if moves[2] == player && moves[4] == player && moves[6] == player {
            
            return true
        }
        return false
    }
    
}
