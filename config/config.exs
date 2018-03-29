use Mix.Config

config :aliyun, oss_access_key_id: {:system, "OSS_ACCESS_KEY_ID"}
config :aliyun, oss_access_key_secret: {:system, "OSS_ACCESS_KEY_SECRET"}
config :aliyun, oss_endpoint: {:system, "OSS_ENDPOINT", "oss-cn-shanghai.aliyuncs.com"}
config :aliyun, sms_access_key_id: {:system, "SMS_ACCESS_KEY_ID"}
config :aliyun, sms_access_key_secret: {:system, "SMS_ACCESS_KEY_SECRET"}
config :aliyun, sms_endpoint: {:system, "SMS_ENDPOINT", "dysmsapi.aliyuncs.com"}
config :aliyun, sms_signature_version: {:system, "SMS_SignatureVersion", "1.0"}
config :aliyun, sms_version: {:system, "SMS_VERSION", "2017-05-25"}
config :aliyun, sms_region_id: {:system, "SMS_REGION_ID", "cn-hangzhou"}

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
