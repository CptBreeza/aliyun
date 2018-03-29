require Logger

defmodule Aliyun.OSS.CLI do
  @moduledoc """
    阿里云OSS库
  """
  import SweetXml
  alias Aliyun.OSS.Mime, as: Mime

  @doc """
    获取所有Buckets信息.
    iex> Aliyun.OSS.CLI.list_buckets
  """
  def list_buckets(oss_endpoint \\ Aliyun.Env.oss_endpoint) do
    string_to_sign = "GET\n\n\n#{format_gmt_time()}\n/"
    signature = gen_signature(string_to_sign)
    headers = ["Authorization": "OSS #{Aliyun.Env.oss_access_key_id}:#{signature}", "Date": format_gmt_time()]
    case HTTPoison.get(oss_endpoint, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        buckets = body |> xpath(~x"//ListAllMyBucketsResult/Buckets/Bucket"l,
          name: ~x"./Name/text()",
          location: ~x"./Location/text()",
          creation_date: ~x"./CreationDate/text()",
          extranet_endpoint: ~x"./ExtranetEndpoint/text()",
          intranet_endpoint: ~x"./IntranetEndpoint/text()",
        )
        {:ok, 200, buckets}
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        error = body |> xpath(~x"//Error", code: ~x"./Code/text()", message: ~x"./Message/text()")
        {:ok, status_code, error}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
    创建Bucket.
    iex> Aliyun.OSS.CLI.create_bucket("icb-data")
  """
  def create_bucket(bucket, oss_endpoint \\ Aliyun.Env.oss_endpoint, acl \\ :private) do
    string_to_sign = "PUT\n\napplication/octet-stream\n#{format_gmt_time()}\nx-oss-acl:#{acl}\n/#{bucket}/"
    signature = gen_signature(string_to_sign)
    headers = ["Authorization": "OSS #{Aliyun.Env.oss_access_key_id}:#{signature}", "Date": format_gmt_time(), "X-OSS-ACL": "#{acl}"]
    url = bucket <> "." <> oss_endpoint
    case HTTPoison.put(url, "", headers) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        Logger.info("create_bucket##{bucket}", filter: :oss)
        {:ok, 200}
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        error = body |> xpath(~x"//Error", code: ~x"./Code/text()", message: ~x"./Message/text()")
        {:ok, status_code, error}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
    删除Bucket.
    iex> Aliyun.OSS.CLI.delete_bucket("icb-data")
  """
  def delete_bucket(bucket, oss_endpoint \\ Aliyun.Env.oss_endpoint) do
    string_to_sign = "DELETE\n\n\n#{format_gmt_time()}\n/#{bucket}/"
    signature = gen_signature(string_to_sign)
    headers = ["Authorization": "OSS #{Aliyun.Env.oss_access_key_id}:#{signature}", "Date": format_gmt_time()]
    url = bucket <> "." <> oss_endpoint
    case HTTPoison.delete(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 204}} ->
        Logger.info("delete_bucket##{bucket}", filter: :oss)
        {:ok, 200}
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        error = body |> xpath(~x"//Error", code: ~x"./Code/text()", message: ~x"./Message/text()")
        {:ok, status_code, error}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
    列出Bucket下所有对象信息.
    iex> Aliyun.OSS.CLI.list_objects("icb-data")
  """
  def list_objects(bucket, oss_endpoint \\ Aliyun.Env.oss_endpoint) do
    string_to_sign = "GET\n\n\n#{format_gmt_time()}\n/#{bucket}/"
    signature = gen_signature(string_to_sign)
    headers = ["Authorization": "OSS #{Aliyun.Env.oss_access_key_id}:#{signature}", "Date": format_gmt_time()]
    url = bucket <> "." <> oss_endpoint
    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        objects = body |> xpath( ~x"//ListBucketResult/Contents"l,
          name: ~x"./Key/text()",
          last_modified: ~x"./LastModified/text()",
          etag: ~x"./ETag/text()",
          size: ~x"./Size/text()"
        ) |> Enum.map(fn %{name: name, last_modified: last_modified, etag: etag, size: size} -> %{name: List.to_string(name), last_modified: last_modified, etag: etag, size: size} end)
        {:ok, 200, objects}
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        error = body |> xpath(~x"//Error", code: ~x"./Code/text()", message: ~x"./Message/text()")
        {:ok, status_code, error}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
    上传文件对象.
    iex> Aliyun.OSS.CLI.put_object("icb-data", "irps/passport.png", "passport.png")
    :ok
  """
  def put_object(bucket, object_key, file_name, oss_endpoint \\ Aliyun.Env.oss_endpoint) do
    mime = Mime.path(object_key)
    stream = File.read!(file_name)
    string_to_sign = "PUT\n\n#{mime}\n#{format_gmt_time()}\n/#{bucket}/#{object_key}"
    signature = gen_signature(string_to_sign)
    headers = ["Authorization": "OSS #{Aliyun.Env.oss_access_key_id}:#{signature}", "Date": format_gmt_time(), "Content-Type": mime]
    url = bucket <> "." <> oss_endpoint <> "/#{object_key}"
    case HTTPoison.put(url, stream, headers) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        Logger.info("put_object#@#{bucket}#{object_key}", filter: :oss)
        {:ok, 200}
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        error = body |> xpath(~x"//Error", code: ~x"./Code/text()", message: ~x"./Message/text()")
        {:ok, status_code, error}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
    上传文件对象.
    iex> Aliyun.OSS.CLI.put_stream_object("icb-data", "irps/passport.png", File.read!("passport.png"))
  """
  def put_stream_object(bucket, object_key, stream, oss_endpoint \\ Aliyun.Env.oss_endpoint) do
    mime = Mime.path(object_key)
    string_to_sign = "PUT\n\n#{mime}\n#{format_gmt_time()}\n/#{bucket}/#{object_key}"
    signature = gen_signature(string_to_sign)
    headers = ["Authorization": "OSS #{Aliyun.Env.oss_access_key_id}:#{signature}", "Date": format_gmt_time(), "Content-Type": mime]
    url = bucket <> "." <> oss_endpoint <> "/#{object_key}"
    case HTTPoison.put(url, stream, headers) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        Logger.info("put_stream_object@#{bucket}##{object_key}", filter: :oss)
        {:ok, 200}
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        error = body |> xpath(~x"//Error", code: ~x"./Code/text()", message: ~x"./Message/text()")
        {:ok, status_code, error}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
    文件对象是否存在.
    iex> ICB.OSS.CLI.object_exist?("icb-data", "irps/passport.png")
  """
  def object_exists?(bucket, object_key, oss_endpoint \\ Aliyun.Env.oss_endpoint) do
    string_to_sign = "HEAD\n\n\n#{format_gmt_time()}\n/#{bucket}/#{object_key}"
    signature = gen_signature(string_to_sign)
    headers = ["Authorization": "OSS #{Aliyun.Env.oss_access_key_id}:#{signature}", "Date": format_gmt_time()]
    url = bucket <> "." <> oss_endpoint <> "/#{object_key}"
    case HTTPoison.head(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        true
      _ ->
        false
    end
  end

  @doc """
    删除文件对象.
    iex> ICB.OSS.CLI.delete_object("icb-data", "irps/passport.png")
  """
  def delete_object(bucket, object_key, oss_endpoint \\ Aliyun.Env.oss_endpoint) do
    string_to_sign = "DELETE\n\n\n#{format_gmt_time()}\n/#{bucket}/#{object_key}"
    signature = gen_signature(string_to_sign)
    headers = ["Authorization": "OSS #{Aliyun.Env.oss_access_key_id}:#{signature}", "Date": format_gmt_time()]
    url = bucket <> "." <> oss_endpoint <> "/#{object_key}"
    case HTTPoison.delete(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 204}} ->
        Logger.info("delete_object##{object_key}@#{bucket}", filter: :oss)
        {:ok, 200}
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        error = body |> xpath(~x"//Error", code: ~x"./Code/text()", message: ~x"./Message/text()")
        {:ok, status_code, error}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp gen_signature(string_to_sign) do
    :crypto.hmac(:sha, Aliyun.Env.oss_access_key_secret, string_to_sign) |> Base.encode64
  end

  defp format_gmt_time do
    Timex.format!(Timex.now, "%a, %d %b %Y %H:%M:%S GMT", :strftime)
  end
end