require 'yaml'
require 'action_mailer'
require 'utf8-cleaner'
use UTF8Cleaner::Middleware

require "#{File.expand_path(File.dirname(__FILE__))}/file_mailer"

settings = YAML::load_file './config.yml'
file_mtime_path = './file_mtime.txt'

ActionMailer::Base.smtp_settings = {
    :user_name => settings['email']['user_name'],
    :password => settings['email']['password'],
    :domain => settings['email']['domain'],
    :address => settings['email']['address'],
    :port => settings['email']['port'],
    :authentication => :plain,
    :enable_starttls_auto => true
}

file_mtime_in = {}

file_mtime_in =  YAML::load_file(file_mtime_path) if File.exist?(file_mtime_path)

file_mtime = {}
changed_content = []
Dir.glob(settings['watch']['files'].split(',')).each do |f|
  file_mtime[f] = File.stat(f).mtime.to_i
  if file_mtime_in.include?(f)
    changed_content << f if file_mtime[f] != file_mtime_in[f] # File mtime is different
  else
    # New File
    changed_content << f
  end
end

File.open(file_mtime_path, 'w') { |file| file.write(file_mtime.to_yaml) }

FileMailer.experror(changed_content,  settings['email']['to']).deliver_now if changed_content.length > 0