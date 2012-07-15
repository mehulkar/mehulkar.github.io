class ProjectsController < ApplicationController
  def new
  	@project = Project.new
  end

  def index
  	@projects = Project.all
  end

  def show
  	@project = Project.find(params[:id])
  end

  def create
  	@project = Project.new(params[:project])
  	if @project.save
  		redirect_to projects_path
  	else
  		render 'new'
  	end
  end
end
