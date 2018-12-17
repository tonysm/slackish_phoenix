import { Socket } from "phoenix"

export function connector(token) {
  let socket = new Socket("/socket", { params: { token } })

  socket.connect();

  return socket;
}
