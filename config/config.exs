use Mix.Config

config :aliyun, :access_key_id, {:system, "ACCESS_KEY_ID", "LTAICAZuQAWdVCG3"}
config :aliyun, :access_key_secret, {:system, "ACCESS_KEY_SECRET", "c7Lq7I2ecSxf8ovVzOFvTuQnjVGXRT"}
config :aliyun, oss_endpoint: {:system, "OSS_ENDPOINT", "oss-cn-shanghai.aliyuncs.com"}
config :aliyun, sms_endpoint: {:system, "SMS_ENDPOINT", "dysmsapi.aliyuncs.com"}
config :aliyun, sms_signature_version: {:system, "SMS_SignatureVersion", "1.0"}
config :aliyun, sms_version: {:system, "SMS_VERSION", "2017-05-25"}
config :aliyun, sms_region_id: {:system, "SMS_REGION_ID", "cn-hangzhou"}
config :aliyun, sms_sign_name: {:system, "SMS_SIGN_NAME", "杭州阿尔法"}
