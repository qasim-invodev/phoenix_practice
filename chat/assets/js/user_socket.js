// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import {Socket, Presence} from "phoenix"

// And connect to the path in "lib/chat_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let name = document.getElementById("User").innerText
let socket = new Socket("/socket", {params: {token: window.userToken, name: name}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/chat_web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/chat_web/templates/layout/app.html.heex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/chat_web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

let presences = {}

let formatTimestamp = (timestamp) => {

  let date = new Date(parseInt(timestamp))
  return date.toLocaleTimeString()
}

let listBy = (user, {metas: metas}) => {
  return {
    user: user,
    onlineAt: formatTimestamp(metas[0].online_at)
  }
}

let userList = document.getElementById("UserList")
let render = (presences) => {
  userList.innerHTML = Presence.list(presences, listBy)
    .map(presence => `
      <li>
        ${presence.user}
        <br>
        <small>online since ${presence.onlineAt}</small>
      </li>
    `)
    .join("")
}

// Channels
let room = socket.channel("room:lobby")
room.on("presence_state", state => {
  presences = Presence.syncState(presences, state)
  render(presences)
})

room.on("presence_diff", diff => {
  presences = Presence.syncDiff(presences, diff)
  render(presences)
})

room.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })


let messageInput = document.getElementById("NewMessage")
messageInput.addEventListener("keypress", event => {
  if(event.key === 'Enter'){
    room.push("message:new", {body: messageInput.value})
    messageInput.value = ""
  }
})

let messageList = document.getElementById("MessageList")
// let renderMessage = (message) => {
//   let messageElement = document.createElement("li")
//   messageElement.innerHTML = `
//     <b>${message.name}</b>
//     <i>${formatTimestamp(message.timestamp)}</i>
//     <p>${message.body}</p>
//   `
//   messageList.appendChild(messageElement)
//   messageList.scrollTop = messageList.scrollHeight;
// }

room.on("message:new",  payload => {
  let messageItem = document.createElement("li")
  messageItem.innerHTML = `
    <b>${payload.user}</b>
    <i>${formatTimestamp(payload.timestamp)}</i>
    <p>${payload.body.body}</p>
  `
  // messageItem.innerText = `[${Date()}] ${payload.body}`
  messageList.appendChild(messageItem)
})
// Now that you are connected, you can join channels with a topic.
// Let's assume you have a channel with a topic named `room` and the
// subtopic is its id - in this case 42:
// channel.join()
//   .receive("ok", resp => { console.log("Joined successfully", resp) })
//   .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
