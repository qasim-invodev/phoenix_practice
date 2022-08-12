defmodule Blogs.GenServer.PdfCreator do
  use GenServer
  require Logger

  @wait_timer 3_000
  @name __MODULE__
  #Client API
  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, false, opts ++ [name: @name, hibernate_after: @wait_timer])
  end

  def save_pdf(html) do
    GenServer.call(@name, {:save_pdf, html}, @wait_timer)
  end

  #Server Side Logic
  @impl GenServer
  def init(state) do
    if is_boolean(state) do
      {:ok, state}
    else
      {:stop, "State is not a Boolean"}
    end
  end

  @impl GenServer
  def handle_call({:save_pdf, html}, _from, _state) do
    reply = download_pdf(html)
    new_state = true
    Logger.info("PDF Generation with Status #{reply}")
    {:reply, reply, new_state, @wait_timer}
  end

  @impl GenServer
  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

  defp download_pdf(html) do
    {:ok, filename} = PdfGenerator.generate(html, page_size: "A4", shell_params: ["--dpi", "300"])
    :ok = File.rename(filename, "./priv/static/post_pdfs/post_#{DateTime.utc_now()}.pdf")
    :ok
  end
end
