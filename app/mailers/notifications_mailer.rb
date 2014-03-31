# coding: utf-8
class NotificationsMailer < ActionMailer::Base

	default from: 'mariusz.blaszczak@gmail.com'

  def new_message(task)
    @task = task
    mail(:to => @task.email, :subject => "Download your kindle document!")
  end

end