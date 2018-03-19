use Mix.Config

config :aliyun, :access_key_id, {:system, "ACCESS_KEY_ID"}
config :aliyun, :access_key_secret, {:system, "ACCESS_KEY_SECRET"}
config :aliyun, oss_endpoint: {:system, "OSS_ENDPOINT"}
config :aliyun, sms_endpoint: {:system, "SMS_ENDPOINT", "dysmsapi.aliyuncs.com"}
config :aliyun, sms_signature_version: {:system, "SMS_SignatureVersion", "1.0"}
config :aliyun, sms_version: {:system, "SMS_VERSION", "2017-05-25"}
config :aliyun, sms_region_id: {:system, "SMS_REGION_ID", "cn-hangzhou"}
config :aliyun, sms_sign_name: {:system, "SMS_SIGN_NAME"}