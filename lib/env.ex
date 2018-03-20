defmodule Aliyun.Env do
  def oss_endpoint do
    Application.get_env(:aliyun, :oss_endpoint)
  end

  def oss_access_key_id do
    Application.get_env(:aliyun, :oss_access_key_id) || Application.get_env(:aliyun, :access_key_id)
  end

  def oss_access_key_secret do
    Application.get_env(:aliyun, :oss_access_key_secret) || Application.get_env(:aliyun, :access_key_secret)
  end

  def sms_endpoint do
    Application.get_env(:aliyun, :sms_endpoint)
  end

  def sms_access_key_id do
    Application.get_env(:aliyun, :sms_access_key_id) || Application.get_env(:aliyun, :access_key_id)
  end

  def sms_access_key_secret do
    Application.get_env(:aliyun, :sms_access_key_secret) || Application.get_env(:aliyun, :access_key_secret)
  end

  def sms_signature_version do
    Application.get_env(:aliyun, :sms_signature_version)
  end

  def sms_version do
    Application.get_env(:aliyun, :sms_version)
  end

  def sms_region_id do
    Application.get_env(:aliyun, :sms_region_id)
  end

  def sms_sign_name do
    Application.get_env(:aliyun, :sms_sign_name)
  end
end
