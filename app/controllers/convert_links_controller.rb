class ConvertLinksController < ApplicationController
	before_filter :authenticate_user!

  def new
  	@book_task = BookTask.new
		@book_task.email = current_user.email
  end

  def create
  	@book_task = BookTask.new(params[:book_task])
		@book_task.name = "links"
		if @book_task.save
			flash[:notice] = "Your request has been processed! The book will be send to your e-mail."
			redirect_to "/"
		else
			flash[:alert] = "Please, fill all fields correctly!"
			render :new
		end
  end

end