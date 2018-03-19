defmodule Aliyun.SMS.CLI do
  @moduledoc """
    阿里云SMS库
  """
  alias Aliyun.Config, as: Config

  @sms_endpoint Config.get(:aliyun, :sms_endpoint)
  @sms_access_key_id Config.get(:aliyun, :access_key_id) || Config.get(:aliyun, :sms_access_key_id)
  @sms_access_key_secret Config.get(:aliyun, :access_key_secret) || Config.get(:aliyun, :sms_access_key_secret)
  @sms_signature_version Config.get(:aliyun, :sms_signature_version)
  @sms_version Config.get(:aliyun, :sms_version)
  @sms_region_id Config.get(:aliyun, :sms_region_id)
  @sms_sign_name Config.get(:aliyun, :sms_sign_name)

  def send(phone_numbers, template_code, template_param) do
    arguments = format_arguments(phone_numbers, template_code, template_param)
    signature = gen_signature(arguments)
    body = [{"Signature", signature} | arguments]
    case HTTPoison.post(@sms_endpoint, {:form, body}) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, 200, Poison.decode!(body)}
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:ok, status_code, Poison.decode!(body)}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp gen_signature(arguments, method \\ "POST") do
    args = arguments |> Enum.map(fn {key, val} -> {url_encode(key), url_encode(val)} end) |> Enum.map(fn {key, val} -> "#{key}=#{val}" end) |> Enum.join("&")
    string_to_sign = "#{String.upcase(method)}" <> "&" <> url_encode("/") <> "&" <> url_encode(args)
    :crypto.hmac(:sha, "#{@sms_access_key_secret}&", string_to_sign) |> Base.encode64
  end

  defp format_arguments(phone_numbers, template_code, template_param) do
    %{
      "SignatureMethod" => "HMAC-SHA1",
      "SignatureNonce" => UUID.uuid1(),
      "AccessKeyId" => @sms_access_key_id,
      "SignatureVersion" => @sms_signature_version,
      "Timestamp" => format_gmt_time(),
      "Format" => "JSON",
      "Action" => "SendSms",
      "Version" => @sms_version,
      "RegionId" => @sms_region_id,
      "PhoneNumbers" => phone_numbers,
      "SignName" => @sms_sign_name,
      "TemplateParam" => Poison.encode!(template_param),
      "TemplateCode" => template_code
    } |> Enum.sort_by(fn {key, _} -> key end)
  end

  defp format_gmt_time do
    Timex.format!(Timex.now, "%Y-%m-%dT%H:%M:%SZ", :strftime)
  end

  defp url_encode(text) do
    URI.encode_www_form(text) |> String.replace("%2B", "%20") |> String.replace("%7E", "~")
  end
end