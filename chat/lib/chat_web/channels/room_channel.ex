defmodule ChatWeb.RoomChannel do
  use ChatWeb, :channel

  alias Chat.{
    Message,
    Repo
  }
  alias ChatWeb.{
    MessageView,
    Presence
  }
  # @impl true
  # def join("room:lobby", payload, socket) do
  #   if authorized?(payload) do
  #     {:ok, socket}
  #   else
  #     {:error, %{reason: "unauthorized"}}
  #   end
  # end

  @impl true
  def join("room:lobby", _params, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  @impl true
  def join(_others, _params, _socket) do
    {:error, "Room does not exist"}
  end

  @impl true
  def handle_info(:after_join, socket) do
    socket
    |> track_presence
    |> send_recent_messages

    {:noreply, socket}
  end

  @impl true
  def handle_in("message:new", body, socket) do
    IO.inspect(body)
    message = Repo.insert! %Message{
      topic: socket.topic,
      user: socket.assigns.user,
      body: Map.get(body, "body")
    }
    broadcast! socket, "message:new", MessageView.render("message.json",%{message: message})
    {:noreply, socket}
  end

  defp track_presence(socket) do
    push(socket, "presence_state", Presence.list(socket))
    Presence.track(socket, socket.assigns.user, %{
      online_at: inspect(:os.system_time(:milli_seconds))
    })
    socket
  end

  defp send_recent_messages(socket) do
    messages =
      socket.topic
      |> Message.recent
      |> Repo.all

    push(socket, "messages:recent", MessageView.render("index.json", %{messages: messages}))
    socket
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  # @impl true
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end

  # # It is also common to receive messages from the client and
  # # broadcast to everyone in the current topic (room:lobby).
  # @impl true
  # def handle_in("shout", payload, socket) do
  #   broadcast(socket, "shout", payload)
  #   {:noreply, socket}
  # end

  # # Add authorization logic here as required.
  # defp authorized?(_payload) do
  #   true
  # end
end
