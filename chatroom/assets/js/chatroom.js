// import {Socket, Presence} from "phoenix"

// class Chat {
//     constructor(roomName) {
//         this.presences = {}
//         this.roomName = roomName
//         this.userList = document.getElementById("user-list")
//         this.renderPresences = this.renderPresences.bind(this)
//     }

//     initialize () {
//         // Ask for user's name
//         this.user = window.prompt("What is your name?") || "Anonymous"

//         // Setting up the websocket Connection
//         this.socket = new Socket('/socket', {params: {user: this.user}})

//         //Setting up the room
//         this.socket.channel(roomName)

//         //sync presence state
//         this.room.on("presence_state", state => {
//             this.presences = Presence.syncState(this.presences, state)
//             this.renderPresences(this.presences)
//         })

//         this.room.on("presence_diff", state => {
//             this.presences = Presence.syncDiff(this.presences, state)
//             this.renderPresences(this.presences)
//         })

//         //Join the room
//         this.room.join()
//     }

//     formatPresences (presences) {

//     }

//     // renderPresences (presences) {
//     //     let html = this.formatPresences(presences).map(presence => '
//     //         <li>
//     //             ${presence.user}
//     //             <br />
//     //             <small>online since ${presence.onlineAt}</small>
//     //         </li>
//     //         ').join('')
//     // }
// }

// export default Chat