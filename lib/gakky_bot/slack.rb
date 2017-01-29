require 'slack-notifier'
SECRETS = YAML.load_file(File.expand_path("../config/secrets.yml", __FILE__))

$notifier = Slack::Notifier.new SECRETS['webhook_url']
