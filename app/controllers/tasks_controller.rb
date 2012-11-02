class TasksController < ApplicationController

  before_filter :init_project
  before_filter :check_started, :only => :start

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    authorize! :manage_tasks, @project

    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    authorize! :manage_tasks, @project

    @task = @project.tasks.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /tasks/1/edit
  def edit
    authorize! :manage_tasks, @project

    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create
    authorize! :manage_tasks, @project

    @task = @project.tasks.new({
      :name => params[:task][:name],
      :description => params[:task][:description]
    })

    respond_to do |format|
      if @task.save
        format.html { redirect_to @project, notice: 'Task was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    authorize! :manage_tasks, @project

    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes({
        :name => params[:task][:name],
        :description => params[:task][:description]
      })
        format.html { redirect_to @project, notice: 'Task was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    authorize! :manage_tasks, @project

    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to @project }
    end
  end

  def start
    @task = Task.find(params[:task_id])

    authorize! :start, @task

    run_at = {}
    run_at.merge!(:run_at => Time.now) unless @task.stopped?

    @task.update_attributes({ :stop_at => nil, :status => Task::STATUS[:started] }.merge!(run_at))

    respond_to do |format|
      format.js {render 'update_task_content'}
    end
  end

  def stop
    @task = Task.find(params[:task_id])

    authorize! :stop, @task

    @task.update_attributes({:stop_at => Time.now, :status => Task::STATUS[:stopped]})

    respond_to do |format|
      format.js {render 'update_task_content'}
    end
  end

  def close
    authorize! :manage_tasks, @project

    @task = Task.find(params[:task_id])

    new_params = {}
    new_params.merge!({:stop_at => Time.now}) if @task.stop_at.nil?
    new_params.merge!({:run_at => Time.now}) if @task.run_at.nil?
    new_params.merge!({:status => Task::STATUS[:closed]})

    @task.update_attributes(new_params)

    respond_to do |format|
      format.js {render 'update_task_content'}
    end
  end

  private
    def init_project
      @project = Project.find(params[:project_id])
    end

    def check_started
      Task.update_all({:stop_at => Time.now, :status => Task::STATUS[:stopped]}, {:id => Task.for_user(current_user).started.collect{|t|t.id}})
    end
end
