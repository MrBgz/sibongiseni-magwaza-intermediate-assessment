class TasksController < ApplicationController
  before_action :set_task, only: %i[update destroy]

  def index
    @todo_tasks = Task.todo
    @completed_tasks = Task.completed
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to root_path
    else
      @todo_tasks = Task.todo
      @completed_tasks = Task.completed

      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(completed: true)
      redirect_to root_path
    else
      redirect_to root_path, alert: "Unable to update task."
    end
  end

  def destroy
    @task.destroy
    redirect_to root_path
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description)
  end
end
