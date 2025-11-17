import SwiftUI

// MARK: - Chat Bubbles
struct ChatBubbleLeft: View {
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.custom("PressStart2P-Regular", size: 9))
                .padding(12)
                .background(
                    Image("container")
                        .resizable()
                        .scaledToFit()
                )
                .fixedSize(horizontal: true, vertical: false)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct ChatBubbleRight: View {
    let text: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.custom("PressStart2P-Regular", size: 9))
                .padding(12)
                .background(
                    Image("container")
                        .resizable()
                        .scaledToFit()
                )
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal)
    }
}

// MARK: - Drawer
struct DrawerContent: View {
    let conversations: [Conversation]
    let onConversationClick: (Conversation) -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image("x_icon")
                        .resizable()
                        .frame(width: 28, height: 28)
                }
            }
            .padding(.bottom, 12)
            
            Text("HISTORY")
                .font(.custom("PressStart2P-Regular", size: 14))
                .padding(.vertical, 8)
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(conversations) { conv in
                        Button(action: { onConversationClick(conv) }) {
                            ZStack {
                                Image("container")
                                    .resizable()
                                    .frame(height: 60)
                                    .cornerRadius(8)
                                Text(conv.title)
                                    .font(.custom("PressStart2P-Regular", size: 12))
                                    .foregroundColor(.black)
                                    .padding(.leading, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .frame(width: 260)
        .padding(16)
        .background(Color(red: 254/255, green: 238/255, blue: 176/255))
    }
}

// MARK: - Chat Page with Drawer
struct ChatPageWithDrawer: View {
    @ObservedObject var viewModel: ChatViewModel
    let userId: String
    
    @State private var showDrawer: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            ChatPage(viewModel: viewModel, userId: userId, onMenuClick: {
                withAnimation { showDrawer.toggle() }
            })
            
            if showDrawer {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation { showDrawer = false }
                    }
                
                DrawerContent(conversations: viewModel.conversations,
                              onConversationClick: { conv in
                                  viewModel.selectConversation(conv)
                                  withAnimation { showDrawer = false }
                              },
                              onClose: { withAnimation { showDrawer = false } })
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: showDrawer)
    }
}

// MARK: - Chat Page
struct ChatPage: View {
    @ObservedObject var viewModel: ChatViewModel
    let userId: String
    let onMenuClick: () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                TopBar(title: viewModel.selectedConversation?.title ?? "NEW QUEST", onMenuClick: onMenuClick)
                
                ChatScrollView(viewModel: viewModel, userId: userId)
                    .environmentObject(viewModel)
                
                InputBar()
                    .environmentObject(viewModel)
            }
        }
    }
}

// MARK: - Background
struct BackgroundView: View {
    var body: some View {
        Image("background_general")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

// MARK: - Top Bar
struct TopBar: View {
    let title: String
    let onMenuClick: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onMenuClick) {
                Image("burger_icon")
                    .resizable()
                    .frame(width: 28, height: 28)
            }
            
            Spacer()
            
            Text(title)
                .font(.custom("PressStart2P-Regular", size: 14))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 16)
    }
}

// MARK: - Chat ScrollView
struct ChatScrollView: View {
    @ObservedObject var viewModel: ChatViewModel
    let userId: String

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.messages) { msg in
                        ChatMessageView(msg: msg, userId: userId)
                            .id(msg.id)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .onChange(of: viewModel.messages.count) { _ in
                if let last = viewModel.messages.last {
                    withAnimation {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
    }
}

// MARK: - Chat Message
struct ChatMessageView: View {
    let msg: Message
    let userId: String

    var body: some View {
        if msg.sender == "user" {
            ChatBubbleRight(text: msg.content)
        } else {
            ChatBubbleLeft(text: msg.content)
        }
    }
}

// MARK: - Input Bar
struct InputBar: View {
    @EnvironmentObject var viewModel: ChatViewModel
    
    var body: some View {
        ZStack {
            Image("container")
                .resizable()
                .scaledToFill()
                .frame(height: 55)
                .clipped()
            
            HStack(spacing: 12) {
                Button(action: { print("Camera tapped") }) {
                    Image("add_image_button")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                
                TextField("Type your message…", text: $viewModel.messageInput)
                    .font(.custom("PressStart2P-Regular", size: 12))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.45), lineWidth: 1)
                    )
                
                Button(action: { viewModel.sendMessage() }) {
                    Image("send")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.horizontal)
        .padding(.bottom, 40)
    }
}
