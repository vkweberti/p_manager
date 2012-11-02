module TasksHelper

  def total_time task
    if task.run_at
      total_time = (task.stop_at || Time.now) - task.run_at
      minutes = (total_time / 60) % 60
      hours = total_time / (60 * 60)

      format("%02d:%02d", hours, minutes)
    end
  end

end
