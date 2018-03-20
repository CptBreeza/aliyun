use Mix.Config

config :aliyun, access_key_id: System.get_env("ACCESS_KEY_ID")
config :aliyun, access_key_secret: System.get_env("ACCESS_KEY_SECRET")
config :aliyun, oss_endpoint: (System.get_env("OSS_ENDPOINT") || "oss-cn-shanghai.aliyuncs.com")
config :aliyun, sms_endpoint: (System.get_env("SMS_ENDPOINT") || "dysmsapi.aliyuncs.com")
config :aliyun, sms_signature_version: (System.get_env("SMS_SignatureVersion") || "1.0")
config :aliyun, sms_version: (System.get_env("SMS_VERSION") || "2017-05-25")
config :aliyun, sms_region_id: (System.get_env("SMS_REGION_ID") || "cn-hangzhou")
config :aliyun, sms_sign_name: System.get_env("SMS_SIGN_NAME")

config :logger,
  backends: [:console, {LoggerFileBackend, :oss}, {LoggerFileBackend, :sms}]
  
config :logger, :oss,
  path: "logs/oss.log",
  level: :info,
  metadata_filter: [filter: :oss]

config :logger, :sms,
  path: "logs/sms.log",
  metadata_filter: [filter: :sms],
  level: :info
