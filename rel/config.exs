Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"k2tf]Kj.R%p@yb!C}z3(CVd`u^7%1n,r,Uy~BF`lVFZNFB4o.eqe)D?=P?p,^[>z"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"CXvzPytm.$]K_N<HMm^tO}]H]^`fXc9F4^WOXZn/RA$?P.*2>=?.)3Z?wJ|m.T/l"
end

release :aliyun do
  set version: current_version(:aliyun)
  set applications: [
    :runtime_tools
  ]
end

