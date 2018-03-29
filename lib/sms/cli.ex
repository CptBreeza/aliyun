require Logger

defmodule Aliyun.SMS.CLI do
  @moduledoc """
    阿里云SMS库
  """

  def send(phone_numbers, template_code, template_param, sign_name) do
    arguments = format_arguments(phone_numbers, template_code, template_param, sign_name)
    signature = gen_signature(arguments)
    body = [{"Signature", signature} | arguments]
    case HTTPoison.post(Aliyun.Env.sms_endpoint, {:form, body}) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        phone_numbers |> String.split(",") |> Enum.each(fn phone -> Logger.info("[#{template_code}##{phone}] => #{Poison.encode!(template_param)}", filter: :sms) end)
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
    :crypto.hmac(:sha, "#{Aliyun.Env.sms_access_key_secret}&", string_to_sign) |> Base.encode64
  end

  defp format_arguments(phone_numbers, template_code, template_param, sign_name) do
    %{
      "SignatureMethod" => "HMAC-SHA1",
      "SignatureNonce" => UUID.uuid1(),
      "AccessKeyId" => Aliyun.Env.sms_access_key_id,
      "SignatureVersion" => Aliyun.Env.sms_signature_version,
      "Timestamp" => format_gmt_time(),
      "Format" => "JSON",
      "Action" => "SendSms",
      "Version" => Aliyun.Env.sms_version,
      "RegionId" => Aliyun.Env.sms_region_id,
      "PhoneNumbers" => phone_numbers,
      "SignName" => sign_name,
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