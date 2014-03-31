class BookTaskController < ApplicationController

	# Executed from cron. Parse links, create book and send it via email to user.
	# 
	def index
		BookTask.where(downloaded: false).each do |task|
			# Depend on the task
			if task.name == "links"
				website = WebsiteCreator.create(task.links_as_array)
				subpages = website.subpages
			elsif task.name == "blog"
				exploiter = PageExploiter.new(url)
				subpages = exploiter.exploit!
			end

			mobi_creator = MobiCreator.new(subpages, task.title)
			file, dir = mobi_creator.create

			task.update_attributes(dir: dir, file: file, downloaded: true)

			# Send link to ebook via email
			NotificationsMailer.new_message(task).deliver
		end
		redirect_to "/"
	end

end

