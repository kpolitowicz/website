defmodule SocialFeeds do
  @moduledoc """
  The SocialFeeds app endpoint functions.
  """

  alias SocialFeeds.Cache

  @doc """
  Returns the next (upcoming) meetup_event.
  If there is no upcoming event, returns the last (recent) meetup_event.

  This function does not hit external API if there is an unexpired next_meetup_event in cache.
  The default caching period is determined by Cache module, but it can be overriden in ```opts```.

  The following options may be passed in ```opts```:

  * cache_ttl_in_msec - time to cache the result (in milliseconds)

  ## Examples

      iex> get_next_meetup_event()
      %SocialFeeds.Meetup.Event{}

      iex> get_next_meetup_event(%{cache_ttl_in_msec: 600_000})
      %SocialFeeds.Meetup.Event{}

  """
  def get_next_meetup_event(opts \\ %{}) do
    Cache.fetch(:next_meetup_event,
                fn -> SocialFeeds.Meetup.ApiClient.get_next_event() end,
                opts)
  end

  @doc """
  Returns the last 3 videos from the YT channel.

  This function does not hit external API if there is an unexpired next_meetup_event in cache.
  The default caching period is determined by Cache module, but it can be overriden in ```opts```.

  The following options may be passed in ```opts```:

  * cache_ttl_in_msec - time to cache the result (in milliseconds)

  ## Examples

      iex> get_new_yt_videos()
      [%SocialFeeds.Youtube.Video{}, ...]

      iex> get_new_yt_video(%{cache_ttl_in_msec: 600_000})
      [%SocialFeeds.Youtube.Video{}, ...]

  """
  def get_new_yt_videos(opts \\ %{}) do
    Cache.fetch(:new_videos,
                fn -> SocialFeeds.Youtube.ApiClient.get_new_videos() end,
                opts)
  end
end
