require 'action_mailer'
require 'utf8-cleaner'

class FileMailer < ActionMailer::Base

  def experror(files, to_email)
    puts "Sending email on #{files.length} changed files\n"
    body = ''
    files.each { |f| body << tail_file(f)}
    mail(subject: '[Watchman] Files were modified', content_type: 'text/html', body: body.gsub("\n",'<br/>').encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: ''), from: to_email, to: to_email)
  end

  def tail_file(f)
    tail = `tail -100 #{f}`
    "<h1>#{f}</h1><p>#{tail}</p>"
  end
end

